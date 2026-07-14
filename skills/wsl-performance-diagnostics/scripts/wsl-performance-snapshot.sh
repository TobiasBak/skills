#!/usr/bin/env bash
set -uo pipefail

TOP=25
SHOW_HOST=0
SHOW_STORAGE=0
DETAIL_PID=""

usage() {
  cat <<'EOF'
Usage: wsl-performance-snapshot.sh [options]

Non-destructive, bounded WSL2 performance snapshot.

Options:
  --top N       Number of processes to show (default: 25, max: 100)
  --pid PID     Show focused ownership and lifecycle details for one PID
  --host        Include Windows host and VmmemWSL memory when interop works
  --storage     Include a time-bounded /tmp size and age scan
  -h, --help    Show this help
EOF
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 2
}

is_uint() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

section() {
  printf '\n=== %s ===\n' "$1"
}

run_bounded() {
  local seconds="$1"
  shift
  if ! command -v timeout >/dev/null 2>&1; then
    printf 'skipped bounded command because timeout is unavailable: %s\n' "$1" >&2
    return 125
  fi
  timeout --kill-after=2s "$seconds" "$@"
}

while (($#)); do
  case "$1" in
    --top)
      (($# >= 2)) || fail '--top requires a number'
      is_uint "$2" || fail '--top must be an integer'
      ((2 <= 10#$2 && 10#$2 <= 100)) || fail '--top must be between 2 and 100'
      TOP=$((10#$2))
      shift 2
      ;;
    --pid)
      (($# >= 2)) || fail '--pid requires a PID'
      is_uint "$2" || fail '--pid must be an integer'
      DETAIL_PID=$((10#$2))
      shift 2
      ;;
    --host)
      SHOW_HOST=1
      shift
      ;;
    --storage)
      SHOW_STORAGE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown option: $1"
      ;;
  esac
done

print_identity() {
  section 'snapshot'
  printf 'timestamp=%s\n' "$(date --iso-8601=seconds 2>/dev/null || date)"
  printf 'hostname=%s\n' "$(hostname 2>/dev/null || printf unknown)"
  printf 'kernel=%s\n' "$(uname -r 2>/dev/null || printf unknown)"
  printf 'init=%s\n' "$(ps -p 1 -o comm= 2>/dev/null | awk '{$1=$1; print}')"
  if [[ -r /proc/uptime ]]; then
    awk '{printf "uptime_seconds=%.0f\n", $1}' /proc/uptime
  fi
}

print_memory() {
  section 'guest memory'
  if command -v free >/dev/null 2>&1; then
    free -h
  fi
  awk '
    /^(MemTotal|MemFree|MemAvailable|Buffers|Cached|SReclaimable|Shmem|AnonPages|Slab|PageTables|KernelStack|SwapTotal|SwapFree):/ {
      printf "%-16s %12s kB\n", $1, $2
    }
  ' /proc/meminfo

  section 'pressure stalls'
  local file
  for file in /proc/pressure/cpu /proc/pressure/memory /proc/pressure/io; do
    if [[ -r "$file" ]]; then
      printf '%-8s ' "$(basename "$file")"
      tr '\n' ' ' <"$file"
      printf '\n'
    fi
  done

  if command -v vmstat >/dev/null 2>&1; then
    section 'short activity sample'
    vmstat 1 2 2>&1 || true
  fi
}

find_repo_root() {
  local path="$1"
  local steps=0
  [[ "$path" == /* ]] || return 1
  while [[ "$path" != / && $steps -lt 12 ]]; do
    if [[ -e "$path/.git" ]]; then
      printf '%s' "$path"
      return 0
    fi
    path=${path%/*}
    [[ -n "$path" ]] || path=/
    ((steps += 1))
  done
  return 1
}

print_processes() {
  section "top $TOP processes by RSS (KiB)"
  printf '%-7s %-7s %-7s %-5s %-9s %-6s %-6s %-11s %-20s %s\n' \
    PID PPID PGID STAT AGE_S AVGCPU MEM RSS_KIB COMMAND ARGS
  ps -eo pid=,ppid=,pgid=,stat=,etimes=,%cpu=,%mem=,rss=,comm=,args= --sort=-rss 2>/dev/null \
    | head -n "$TOP" \
    | awk '{args=""; for(i=10;i<=NF;i++) args=args (i>10?OFS:"") $i; if(length(args)>180) args=substr(args,1,177) "..."; printf "%-7s %-7s %-7s %-5s %-9s %-6s %-6s %-11s %-20s %s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,args}'

  if command -v top >/dev/null 2>&1; then
    section "top $TOP processes by CPU over a 1 second sample"
    if ! run_bounded 5s env LC_ALL=C top -b -d 1 -n 2 -w 180 2>/dev/null \
      | awk -v limit="$TOP" '/^top -/{frame++; next} frame==2 && $1 ~ /^[0-9]+$/ {print substr($0,1,180); shown++; if(shown>=limit) exit}'; then
      printf 'CPU sample failed or timed out\n'
    fi
  fi

  section 'top process ownership'
  printf '%-7s %-11s %-24s %-42s %s\n' PID RSS_KIB COMMAND CWD REPO
  local pid rss comm cwd repo
  while read -r pid; do
    [[ -r "/proc/$pid/status" ]] || continue
    rss=$(awk '/^VmRSS:/{print $2}' "/proc/$pid/status" 2>/dev/null)
    comm=$(ps -p "$pid" -o comm= 2>/dev/null | awk '{$1=$1; print}')
    cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null || printf '?')
    repo='-'
    if [[ "$cwd" != '?' ]]; then
      repo=$(find_repo_root "$cwd" 2>/dev/null || printf '-')
    fi
    printf '%-7s %-11s %-24.24s %-42.42s %s\n' "$pid" "${rss:-0}" "$comm" "$cwd" "$repo"
  done < <(ps -eo pid= --sort=-rss 2>/dev/null | head -n "$TOP")

  section 'process state summary'
  printf 'processes=%s\n' "$(ps -e --no-headers 2>/dev/null | wc -l | awk '{$1=$1; print}')"
  printf 'threads=%s\n' "$(ps -eLf --no-headers 2>/dev/null | wc -l | awk '{$1=$1; print}')"
  printf 'zombies=%s\n' "$(ps -eo stat= 2>/dev/null | awk '$1 ~ /^Z/{n++} END{print n+0}')"
  printf 'uninterruptible=%s\n' "$(ps -eo stat= 2>/dev/null | awk '$1 ~ /^D/{n++} END{print n+0}')"
  ps -eo pid,ppid,stat,etimes,wchan:32,comm 2>/dev/null \
    | awk 'NR==1 || $3 ~ /^[DZT]/' \
    | head -n "$((TOP + 1))"
}

print_services() {
  if command -v systemctl >/dev/null 2>&1 && [[ "$(ps -p 1 -o comm= 2>/dev/null | awk '{$1=$1; print}')" == systemd ]]; then
    section 'running system services'
    run_bounded 5s systemctl --type=service --state=running --no-pager --plain --legend=no 2>&1 \
      | head -n "$((TOP + 5))" || true
    section 'failed system units'
    run_bounded 5s systemctl --failed --no-pager --plain --legend=no 2>&1 \
      | head -n "$((TOP + 5))" || true
    section 'running user services'
    run_bounded 5s systemctl --user --type=service --state=running --no-pager --plain --legend=no 2>&1 \
      | head -n "$((TOP + 5))" || true
  fi
}

print_pi_runs() {
  local root="/tmp/pi-subagents-uid-$(id -u)/async-subagent-runs"
  command -v jq >/dev/null 2>&1 || return 0
  [[ -d "$root" ]] || return 0

  section 'live Pi async lifecycle records'
  printf '%-10s %-8s %-8s %-10s %-12s %s\n' STATE PID ALIVE AGE_S ACTIVITY RUN_ID
  local status state pid run_id activity mtime now age alive record
  local scanned=0 shown=0 max_records=100 deadline=$((SECONDS + 3))
  now=$(date +%s)
  while IFS= read -r status; do
    [[ -n "$status" ]] || continue
    if ((SECONDS >= deadline)); then
      printf 'time_budget_exhausted=yes scanned=%s displayed=%s\n' "$scanned" "$shown"
      break
    fi
    ((scanned += 1))
    record=$(head -c 65536 "$status" 2>/dev/null \
      | jq -r '[(.state // "unknown" | tostring | .[0:16]), (.pid // 0 | tostring | .[0:16]), (.runId // "unknown" | tostring | .[0:64]), (.activityState // "-" | tostring | .[0:32])] | @tsv' 2>/dev/null) || continue
    IFS=$'\t' read -r state pid run_id activity <<<"$record"
    [[ "$state" =~ ^(running|queued|paused)$ ]] || continue
    mtime=$(stat -c %Y "$status" 2>/dev/null || printf '%s' "$now")
    age=$((now - mtime))
    alive=no
    is_uint "$pid" && [[ -d "/proc/$pid" ]] && alive=yes
    printf '%-10s %-8s %-8s %-10s %-12s %s\n' "$state" "$pid" "$alive" "$age" "$activity" "$run_id"
    ((shown += 1))
    ((shown < TOP)) || break
  done < <(run_bounded 3s find "$root" -mindepth 2 -maxdepth 2 -type f -name status.json -print 2>/dev/null \
    | head -n "$max_records")
  if ((shown >= TOP || scanned >= max_records)); then
    printf 'truncated=yes scanned=%s displayed=%s\n' "$scanned" "$shown"
  fi
}

print_pid_detail() {
  local pid="$1"
  [[ -d "/proc/$pid" ]] || fail "PID $pid does not exist"

  section "PID $pid identity"
  ps -p "$pid" -o user,pid,ppid,pgid,sid,lstart,etimes,stat,%cpu,%mem,rss,vsz,comm 2>&1 || true
  printf 'cwd=%s\n' "$(readlink "/proc/$pid/cwd" 2>/dev/null || printf unreadable)"
  printf 'exe=%s\n' "$(readlink "/proc/$pid/exe" 2>/dev/null || printf unreadable)"
  printf 'cmdline='
  tr '\0' ' ' <"/proc/$pid/cmdline" 2>/dev/null | cut -c1-2000 || true
  printf '\n'
  printf 'cgroup:\n'
  sed 's/^/  /' "/proc/$pid/cgroup" 2>/dev/null || true

  section "PID $pid memory"
  grep -E '^(Name|State|PPid|Threads|VmPeak|VmSize|VmRSS|RssAnon|RssFile|RssShmem|VmSwap):' "/proc/$pid/status" 2>/dev/null || true
  if [[ -r "/proc/$pid/smaps_rollup" ]]; then
    grep -E '^(Rss|Pss|Pss_Anon|Pss_File|Pss_Shmem|Private_Clean|Private_Dirty|Swap):' "/proc/$pid/smaps_rollup" 2>/dev/null || true
  fi

  section "PID $pid parent and direct children"
  local ppid
  ppid=$(awk '/^PPid:/{print $2}' "/proc/$pid/status" 2>/dev/null)
  if is_uint "${ppid:-}"; then
    ps -p "$ppid" -o user,pid,ppid,pgid,sid,lstart,etimes,stat,rss,comm 2>/dev/null || true
  fi
  ps --ppid "$pid" -o user,pid,ppid,pgid,sid,lstart,etimes,stat,rss,comm 2>/dev/null \
    | head -n "$((TOP + 1))" || true

  section "PID $pid deleted open files"
  local fd target found=0 inspected=0 max_fds=$((TOP * 20))
  while IFS= read -r fd; do
    [[ -e "$fd" || -L "$fd" ]] || continue
    ((inspected += 1))
    target=$(readlink "$fd" 2>/dev/null || true)
    if [[ "$target" == *' (deleted)' ]]; then
      printf '%s -> %s\n' "${fd##*/}" "$target"
      found=1
    fi
  done < <(run_bounded 3s find "/proc/$pid/fd" -mindepth 1 -maxdepth 1 -print 2>/dev/null \
    | head -n "$max_fds")
  if ((inspected >= max_fds)); then
    printf 'scan_may_be_truncated=yes inspected=%s\n' "$inspected"
  fi
  ((found == 1)) || printf 'none visible\n'
}

print_host() {
  section 'Windows host and WSL VM'
  if ! command -v powershell.exe >/dev/null 2>&1; then
    printf 'powershell.exe unavailable; host memory not measured\n'
    return
  fi

  local command
  command='$ErrorActionPreference="Stop"; '
  command+='Get-CimInstance Win32_OperatingSystem | Select-Object @{n="TotalGB";e={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}},@{n="FreeGB";e={[math]::Round($_.FreePhysicalMemory/1MB,2)}} | Format-List; '
  command+='Get-Process | Where-Object {$_.ProcessName -match "^(Vmmem|VmmemWSL)$"} | Select-Object Id,ProcessName,@{n="WorkingSetGB";e={[math]::Round($_.WorkingSet64/1GB,2)}},@{n="PrivateGB";e={[math]::Round($_.PrivateMemorySize64/1GB,2)}},CPU | Format-Table -AutoSize; '
  command+='$p=Join-Path $HOME ".wslconfig"; if(Test-Path $p){Write-Output ".wslconfig=$p"; Get-Content $p -TotalCount 100 | ForEach-Object {if($_.Length -gt 240){$_.Substring(0,237) + "..."}else{$_}}}else{Write-Output ".wslconfig=missing"}'

  if ! run_bounded 20s powershell.exe -NoLogo -NoProfile -NonInteractive -Command "$command" 2>&1; then
    printf 'host query failed or timed out; guest snapshot remains valid\n'
  fi
}

print_storage() {
  section 'bounded /tmp storage scan'
  printf 'This optional metadata scan can create I/O load on a large temp tree. Timeout: 30 seconds.\n'
  if ! run_bounded 30s bash -c '
    du -x -B1 --max-depth=1 /tmp 2>/dev/null \
      | sort -n \
      | tail -n "$1"
  ' _ "$TOP"; then
    printf 'size scan failed or timed out before a complete result\n'
  fi

  section 'old /tmp top-level entries'
  if ! run_bounded 5s bash -c '
    find /tmp -mindepth 1 -maxdepth 1 -xdev -printf "%T@\\t%TY-%Tm-%Td %TH:%TM\\t%y\\t%p\\n" 2>/dev/null \
      | sort -n \
      | head -n "$1" \
      | cut -f2-
  ' _ "$TOP"; then
    printf 'age scan failed or timed out\n'
  fi
}

print_identity
print_memory
print_processes
print_services
print_pi_runs
[[ -z "$DETAIL_PID" ]] || print_pid_detail "$DETAIL_PID"
((SHOW_HOST == 0)) || print_host
((SHOW_STORAGE == 0)) || print_storage
