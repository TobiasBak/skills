#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${PI_SKILLS_DIR:-$HOME/.pi/agent/skills}"

# On Windows, Git Bash symlinks can appear as real dirs to native tools.
# Delegate to PowerShell so Pi sees proper SymbolicLink/Junction entries.
if [[ "${OS:-}" == "Windows_NT" ]] || uname -s | grep -qiE 'mingw|msys|cygwin'; then
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$REPO_ROOT/scripts/install-links.ps1")" "$@"
  exit $?
fi

FIX=0
if [[ "${1:-}" == "--fix" || "${1:-}" == "-Fix" ]]; then
  FIX=1
fi

mkdir -p "$TARGET_DIR"

mapfile -t EXTERNAL_SKILLS < <(python3 - <<PY
import json
print(*json.load(open('$REPO_ROOT/skills.json'))['external'], sep='\n')
PY
)
mapfile -t PERSONAL_SKILLS < <(python3 - <<PY
import json
print(*json.load(open('$REPO_ROOT/skills.json'))['personal'], sep='\n')
PY
)

link_skill() {
  local name="$1"
  local source="$2"
  local target="$TARGET_DIR/$name"

  if [ ! -f "$source/SKILL.md" ]; then
    echo "Missing SKILL.md: $source" >&2
    exit 1
  fi

  if [ -L "$target" ]; then
    local actual
    actual="$(readlink "$target")"
    if [ "$(cd "$(dirname "$actual")" 2>/dev/null && pwd)/$(basename "$actual")" = "$(cd "$source" && pwd)" ]; then
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

for skill in "${EXTERNAL_SKILLS[@]}"; do
  link_skill "$skill" "$REPO_ROOT/external/mattpocock-skills/$skill"
done

for skill in "${PERSONAL_SKILLS[@]}"; do
  link_skill "$skill" "$REPO_ROOT/skills/$skill"
done
