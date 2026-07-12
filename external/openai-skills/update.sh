#!/usr/bin/env bash
set -euo pipefail

FORCE=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --force|-Force) FORCE=1 ;;
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
SKILL_PATH="external/openai-skills/openai-docs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PENDING_CHANGES="$(git -C "$REPO_ROOT" status --short -- "$SKILL_PATH")"
if [ -n "$PENDING_CHANGES" ] && [ "$FORCE" -ne 1 ]; then
  echo "Refusing to overwrite the vendored OpenAI Docs skill with uncommitted local changes:" >&2
  echo "$PENDING_CHANGES" >&2
  echo "Review or commit these changes, then rerun. Use --force only when you intentionally want to overwrite them." >&2
  exit 1
fi

git clone --depth 1 --filter=blob:none --sparse https://github.com/openai/skills "$TMP/repo"
git -C "$TMP/repo" sparse-checkout set --no-cone '/skills/.curated/openai-docs'

SOURCE="$TMP/repo/skills/.curated/openai-docs"
if [ ! -f "$SOURCE/SKILL.md" ]; then
  echo "OpenAI Docs skill not found upstream." >&2
  exit 1
fi

rm -rf "$DEST/openai-docs"
cp -R "$SOURCE" "$DEST/openai-docs"

echo "Updated OpenAI Docs skill in $DEST/openai-docs"
echo
echo "Review vendored skill changes before committing:"
git -C "$REPO_ROOT" status --short -- "$SKILL_PATH"
git -C "$REPO_ROOT" --no-pager diff -- "$SKILL_PATH"
