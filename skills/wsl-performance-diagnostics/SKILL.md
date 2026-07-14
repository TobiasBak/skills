---
name: wsl-performance-diagnostics
description: Diagnose WSL2 slowness, high VmmemWSL memory, swap or I/O pressure, stale processes, abandoned agent workers, and repo-owned temporary artifacts. Use when WSL feels slow, Windows reports excessive WSL memory, processes may have leaked, or work from another repository may still be running.
compatibility: WSL2 Linux with Bash, procps, coreutils timeout, and /proc. Optional systemd, jq, and Windows PowerShell improve coverage.
---

# WSL Performance Diagnostics

Use bounded evidence. A diagnostic that recursively scans large logs, repositories, or temp trees can become the workload being diagnosed.

Resolve `SKILL_DIR` to the directory containing this loaded `SKILL.md`, independent of the user's current working directory. Use that absolute path for every bundled command below.

## 1. Establish a baseline

Run the bundled non-destructive snapshot first:

```bash
bash "$SKILL_DIR/scripts/wsl-performance-snapshot.sh"
```

Add Windows host memory only when interop is responsive:

```bash
bash "$SKILL_DIR/scripts/wsl-performance-snapshot.sh" --host
```

Completion criterion: classify the symptom as at least one of process memory, reclaimable cache, swap pressure, CPU contention, I/O pressure, blocked tasks, or host-side WSL retention. Do not infer pressure from Windows `VmmemWSL` or Linux `free` alone.

## 2. Attribute the load

Start with the snapshot's bounded process list. For a suspect PID, inspect identity, ancestry, process group, cgroup, working directory, open deleted files, and direct children:

```bash
bash "$SKILL_DIR/scripts/wsl-performance-snapshot.sh" --pid <PID>
```

Use the working directory and command line to identify the owning repository. Inspect supervisor state before treating a process as stale:

- systemd service: `systemctl status <unit> --no-pager`
- Pi async run: compare its `status.json` state and PID with the live process
- tmux: `tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} pid=#{pane_pid} dead=#{pane_dead} cmd=#{pane_current_command} path=#{pane_current_path}'`
- container, IDE, watcher, benchmark harness, or task runner: inspect its parent and lifecycle record

A process is a cleanup candidate only when evidence ties it to completed, failed, cancelled, or abandoned work. Age, sleeping state, PPID 1, a large virtual size, or an unfamiliar command is not enough.

Read [references/interpretation.md](references/interpretation.md) when memory categories, process states, WSL host behavior, or cleanup ownership are unclear.

Completion criterion: every proposed cleanup target has an exact PID or unit, owner, repository or service, evidence of staleness, and expected effect.

## 3. Terminate through the owner

Present the cleanup plan before mutation. Approval to clean up in the current request covers only targets proven stale by the previous step. Treat active or ambiguous work as a separate confirmation.

Prefer the lifecycle owner:

1. Stop a service, harness, tmux job, container, or async runner through its own interface.
2. Otherwise capture identity with `ps -p <PID> -o pid,ppid,pgid,sid,lstart,stat,args` plus the process start-time token from `/proc/<PID>/stat`, then send `kill -TERM <PID>`.
3. Wait a bounded grace period and verify the PID has the same start-time token. A changed token means PID reuse or respawn, so diagnose the supervisor.
4. Use `kill -KILL <PID>` only for the still-live original process whose cleanup was approved.
5. If it respawns, diagnose the supervisor instead of repeating signals.

A zombie has already exited, so fix or stop the parent that failed to reap it. A `D` state task may not respond until its kernel I/O wait returns. Avoid broad command-line patterns and avoid signalling an entire process group unless every member is in the approved scope.

Completion criterion: each approved target is gone or its remaining blocker and supervisor are identified.

## 4. Measure the result

Run the same snapshot after a short quiet window:

```bash
sleep 10
bash "$SKILL_DIR/scripts/wsl-performance-snapshot.sh"
```

Compare `MemAvailable`, anonymous memory, cache, swap activity, pressure stall information, process RSS, and blocked tasks. If host memory matters, repeat `--host`. A lower process RSS with unchanged `VmmemWSL` can still be a successful process cleanup because WSL may retain reclaimable cache.

Completion criterion: report before and after evidence, what improved, what did not, and residual uncertainty.

## 5. Follow evidence into the owning repo

When a repository repeatedly leaves workers or artifacts behind, inspect its process lifecycle rather than adding machine-wide cleanup:

- child creation, detached sessions, and process-group ownership
- signal and cancellation propagation
- timeouts and all success, failure, and interruption exits
- `wait` or equivalent child reaping
- temp-directory ownership and `finally` or trap cleanup
- completion artifacts that disagree with live runner state
- recursive scans of unbounded logs or results trees

Reproduce the lifecycle failure at the smallest public workflow boundary, then fix the owner and add behavioral coverage for normal completion, failure, cancellation, and restart when relevant.

For disk artifacts, opt into the bounded storage pass only after active owners are known:

```bash
bash "$SKILL_DIR/scripts/wsl-performance-snapshot.sh" --storage
```

## Verification

Use the snapshot as the verification surface. Capture comparable before and after output, prove each terminated identity is absent, and exercise any repo fix through its real runner or cancellation boundary. Report exact commands, results, uncovered paths, and whether host memory was measured or only guest state was available.
