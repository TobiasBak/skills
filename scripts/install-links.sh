#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${PI_SKILLS_DIR:-$HOME/.pi/agent/skills}"

# On Windows, Git Bash symlinks can appear as real dirs to native tools.
# Delegate to PowerShell so Pi sees proper SymbolicLink/Junction entries.
if [[ "${OS:-}" == "Windows_NT" ]] || uname -s | grep -qiE 'mingw|msys|cygwin'; then
  PS_ARGS=()
  for arg in "$@"; do
    case "$arg" in
      --fix) PS_ARGS+=("-Fix") ;;
      *) PS_ARGS+=("$arg") ;;
    esac
  done
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$REPO_ROOT/scripts/install-links.ps1")" "${PS_ARGS[@]}"
  exit $?
fi

FIX=0
if [[ "${1:-}" == "--fix" || "${1:-}" == "-Fix" ]]; then
  FIX=1
fi

mkdir -p "$TARGET_DIR"

discover_skill_sources() {
  if [ -d "$REPO_ROOT/skills" ]; then
    find "$REPO_ROOT/skills" -mindepth 2 -maxdepth 2 -type f -name SKILL.md -print
  fi
  if [ -d "$REPO_ROOT/external" ]; then
    find "$REPO_ROOT/external" -mindepth 3 -maxdepth 3 -type f -name SKILL.md -print
  fi
}

mapfile -t SKILL_SOURCES < <(discover_skill_sources | while IFS= read -r skill_file; do dirname "$skill_file"; done | sort)
declare -A NAME_TO_SOURCE=()
EXPECTED_NAMES=()

for source in "${SKILL_SOURCES[@]}"; do
  name="$(basename "$source")"
  if [[ -n "${NAME_TO_SOURCE[$name]:-}" ]]; then
    echo "Duplicate skill name '$name': ${NAME_TO_SOURCE[$name]}, $source" >&2
    exit 1
  fi
  NAME_TO_SOURCE["$name"]="$source"
  EXPECTED_NAMES+=("$name")
done

link_skill() {
  local name="$1"
  local source="$2"
  local target="$TARGET_DIR/$name"

  if [ ! -f "$source/SKILL.md" ]; then
    echo "Missing SKILL.md: $source" >&2
    exit 1
  fi

  if [ -L "$target" ]; then
    local actual expected
    actual="$(realpath "$target" 2>/dev/null || true)"
    expected="$(realpath "$source")"
    if [ "$actual" = "$expected" ]; then
      echo "OK: $target -> $source"
      return
    fi
    if [ "$FIX" -ne 1 ]; then
      echo "Wrong link target: $target -> $actual; expected $source. Re-run with --fix." >&2
      exit 1
    fi
    rm "$target"
  elif [ -e "$target" ]; then
    if [ "$FIX" -ne 1 ]; then
      echo "Exists but not link: $target. Re-run with --fix to replace." >&2
      exit 1
    fi
    rm -rf "$target"
  fi

  ln -s "$source" "$target"
  echo "Linked: $target -> $source"
}

remove_stale_skill_links() {
  declare -A expected=()
  for name in "${EXPECTED_NAMES[@]}"; do
    expected["$name"]=1
  done

  shopt -s nullglob dotglob
  for target in "$TARGET_DIR"/*; do
    local name
    name="$(basename "$target")"
    if [[ -n "${expected[$name]:-}" ]]; then
      continue
    fi

    if [ -L "$target" ]; then
      if [ "$FIX" -ne 1 ]; then
        echo "Unexpected skill link: $target. Re-run with --fix to remove stale links." >&2
        exit 1
      fi
      rm "$target"
      echo "Removed stale: $target"
      continue
    fi

    if [ "$FIX" -ne 1 ]; then
      echo "Unexpected non-link in skills target: $target" >&2
      exit 1
    fi
    echo "Leaving unexpected non-link in skills target: $target" >&2
  done
  shopt -u nullglob dotglob
}

for skill in "${EXPECTED_NAMES[@]}"; do
  link_skill "$skill" "${NAME_TO_SOURCE[$skill]}"
done

remove_stale_skill_links
