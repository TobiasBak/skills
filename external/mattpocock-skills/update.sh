#!/usr/bin/env bash
set -euo pipefail

FORCE=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --force|-Force)
      FORCE=1
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: $0 [--force]" >&2
      exit 1
      ;;
  esac
  shift
done

DEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$DEST/../.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

SKILL_PATHS=(
  "external/mattpocock-skills/grill-with-docs"
  "external/mattpocock-skills/write-a-skill"
  "external/mattpocock-skills/improve-codebase-architecture"
  "external/mattpocock-skills/tdd"
)

PENDING_CHANGES="$(git -C "$REPO_ROOT" status --short -- "${SKILL_PATHS[@]}")"
if [ -n "$PENDING_CHANGES" ] && [ "$FORCE" -ne 1 ]; then
  echo "Refusing to overwrite vendored skills with uncommitted local changes:" >&2
  echo "$PENDING_CHANGES" >&2
  echo "Review or commit these changes, then rerun. Use --force only when you intentionally want to overwrite them." >&2
  exit 1
fi

git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills "$TMP/repo"
cd "$TMP/repo"
git sparse-checkout set --no-cone \
  skills/productivity/write-a-skill \
  skills/engineering/grill-with-docs \
  skills/engineering/improve-codebase-architecture \
  skills/engineering/tdd

for skill in grill-me grill-with-docs write-a-skill improve-codebase-architecture tdd; do
  rm -rf "$DEST/$skill"
done

cp -R skills/productivity/write-a-skill "$DEST/write-a-skill"
cp -R skills/engineering/grill-with-docs "$DEST/grill-with-docs"
cp -R skills/engineering/improve-codebase-architecture "$DEST/improve-codebase-architecture"
cp -R skills/engineering/tdd "$DEST/tdd"

echo "Updated Matt Pocock skills in $DEST"
echo
echo "Review vendored skill changes before committing:"
git -C "$REPO_ROOT" status --short -- "${SKILL_PATHS[@]}"
git -C "$REPO_ROOT" --no-pager diff -- "${SKILL_PATHS[@]}"
