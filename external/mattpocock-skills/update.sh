#!/usr/bin/env bash
set -euo pipefail

DEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills "$TMP/repo"
cd "$TMP/repo"
git sparse-checkout set --no-cone \
  skills/productivity/caveman \
  skills/productivity/grill-me \
  skills/productivity/write-a-skill \
  skills/engineering/improve-codebase-architecture \
  skills/engineering/tdd

for skill in caveman grill-me write-a-skill improve-codebase-architecture tdd; do
  rm -rf "$DEST/$skill"
done

cp -R skills/productivity/caveman "$DEST/caveman"
cp -R skills/productivity/grill-me "$DEST/grill-me"
cp -R skills/productivity/write-a-skill "$DEST/write-a-skill"
cp -R skills/engineering/improve-codebase-architecture "$DEST/improve-codebase-architecture"
cp -R skills/engineering/tdd "$DEST/tdd"

echo "Updated Matt Pocock skills in $DEST"
