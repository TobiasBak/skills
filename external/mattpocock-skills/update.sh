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

MANAGED_SKILL_PATHS=(
  "external/mattpocock-skills/diagnosing-bugs"
  "external/mattpocock-skills/tdd"
  "external/mattpocock-skills/domain-modeling"
  "external/mattpocock-skills/codebase-design"
  "external/mattpocock-skills/handoff"
  "external/mattpocock-skills/writing-great-skills"
  "external/mattpocock-skills/grilling"
  "external/mattpocock-skills/grill-with-docs"
  "external/mattpocock-skills/improve-codebase-architecture"
  "external/mattpocock-skills/to-prd"
  "external/mattpocock-skills/write-a-skill"
)

PENDING_CHANGES="$(git -C "$REPO_ROOT" status --short -- "${MANAGED_SKILL_PATHS[@]}")"
if [ -n "$PENDING_CHANGES" ] && [ "$FORCE" -ne 1 ]; then
  echo "Refusing to overwrite vendored skills with uncommitted local changes:" >&2
  echo "$PENDING_CHANGES" >&2
  echo "Review or commit these changes, then rerun. Use --force only when you intentionally want to overwrite them." >&2
  exit 1
fi

git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills "$TMP/repo"
cd "$TMP/repo"
git sparse-checkout set --no-cone \
  skills/productivity/handoff \
  skills/productivity/writing-great-skills \
  skills/productivity/grilling \
  skills/engineering/diagnosing-bugs \
  skills/engineering/tdd \
  skills/engineering/domain-modeling \
  skills/engineering/codebase-design \
  skills/engineering/grill-with-docs \
  skills/engineering/improve-codebase-architecture \
  skills/engineering/to-prd

for skill in diagnosing-bugs tdd domain-modeling codebase-design handoff writing-great-skills grilling grill-with-docs improve-codebase-architecture to-prd grill-me write-a-skill; do
  rm -rf "$DEST/$skill"
done

cp -R skills/productivity/handoff "$DEST/handoff"
cp -R skills/productivity/writing-great-skills "$DEST/writing-great-skills"
cp -R skills/productivity/grilling "$DEST/grilling"
cp -R skills/engineering/diagnosing-bugs "$DEST/diagnosing-bugs"
cp -R skills/engineering/tdd "$DEST/tdd"
cp -R skills/engineering/domain-modeling "$DEST/domain-modeling"
cp -R skills/engineering/codebase-design "$DEST/codebase-design"
cp -R skills/engineering/grill-with-docs "$DEST/grill-with-docs"
cp -R skills/engineering/improve-codebase-architecture "$DEST/improve-codebase-architecture"
cp -R skills/engineering/to-prd "$DEST/to-prd"

echo "Updated Matt Pocock skills in $DEST"
echo
echo "Review vendored skill changes before committing:"
git -C "$REPO_ROOT" status --short -- "${MANAGED_SKILL_PATHS[@]}"
git -C "$REPO_ROOT" --no-pager diff -- "${MANAGED_SKILL_PATHS[@]}"
