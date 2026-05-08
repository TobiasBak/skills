#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${PI_SKILLS_DIR:-$HOME/.pi/agent/skills}"
mkdir -p "$TARGET_DIR"

link_skill() {
  local name="$1"
  local source="$2"
  local target="$TARGET_DIR/$name"

  if [ ! -f "$source/SKILL.md" ]; then
    echo "Missing SKILL.md: $source" >&2
    exit 1
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Exists, skipping: $target"
    return
  fi

  ln -s "$source" "$target"
  echo "Linked: $target -> $source"
}

for skill in caveman grill-me write-a-skill improve-codebase-architecture tdd; do
  link_skill "$skill" "$REPO_ROOT/external/mattpocock-skills/$skill"
done

# Link personal skills from ./skills/* too.
for skill in "$REPO_ROOT"/skills/*; do
  [ -d "$skill" ] || continue
  [ -f "$skill/SKILL.md" ] || continue
  link_skill "$(basename "$skill")" "$skill"
done
