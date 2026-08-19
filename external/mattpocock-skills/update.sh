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

SKILL_NAMES=(
  domain-modeling
  grill-with-docs
  grilling
)
UPSTREAM_PATHS=(
  skills/engineering/domain-modeling
  skills/engineering/grill-with-docs
  skills/productivity/grilling
)

git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills "$TMP/repo"
UPSTREAM_COMMIT="$(git -C "$TMP/repo" rev-parse HEAD)"
git -C "$TMP/repo" sparse-checkout set --no-cone \
  '/skills/engineering/domain-modeling' \
  '/skills/engineering/grill-with-docs' \
  '/skills/productivity/grilling'

for upstream_path in "${UPSTREAM_PATHS[@]}"; do
  if [ ! -f "$TMP/repo/$upstream_path/SKILL.md" ]; then
    echo "Selected Matt Pocock skill is missing upstream: $upstream_path" >&2
    exit 1
  fi
done

CURRENT_SKILL_PATHS=()
while IFS= read -r -d '' skill_file; do
  skill_dir="$(dirname "$skill_file")"
  CURRENT_SKILL_PATHS+=("external/mattpocock-skills/$(basename "$skill_dir")")
done < <(find "$DEST" -mindepth 2 -maxdepth 2 -type f -name SKILL.md -print0)

TARGET_SKILL_PATHS=()
for name in "${SKILL_NAMES[@]}"; do
  TARGET_SKILL_PATHS+=("external/mattpocock-skills/$name")
done

mapfile -t MANAGED_SKILL_PATHS < <(
  {
    printf '%s\n' "${CURRENT_SKILL_PATHS[@]}"
    printf '%s\n' "${TARGET_SKILL_PATHS[@]}"
  } | sed '/^$/d' | sort -u
)

if [ "${#MANAGED_SKILL_PATHS[@]}" -gt 0 ]; then
  PENDING_CHANGES="$(git -C "$REPO_ROOT" status --short -- "${MANAGED_SKILL_PATHS[@]}")"
  if [ -n "$PENDING_CHANGES" ] && [ "$FORCE" -ne 1 ]; then
    echo "Refusing to overwrite vendored skills with uncommitted local changes:" >&2
    echo "$PENDING_CHANGES" >&2
    echo "Review or commit these changes, then rerun. Use --force only when you intentionally want to overwrite them." >&2
    exit 1
  fi
fi

PREPARED_ROOT="$TMP/prepared"
PREPARED_DEST="$PREPARED_ROOT/external/mattpocock-skills"
mkdir -p "$PREPARED_DEST"

for i in "${!SKILL_NAMES[@]}"; do
  name="${SKILL_NAMES[$i]}"
  upstream_path="${UPSTREAM_PATHS[$i]}"
  cp -R "$TMP/repo/$upstream_path" "$PREPARED_DEST/$name"

  metadata="$DEST/$name/agents/openai.yaml"
  if [ -f "$metadata" ]; then
    mkdir -p "$PREPARED_DEST/$name/agents"
    cp "$metadata" "$PREPARED_DEST/$name/agents/openai.yaml"
  fi
done

for managed_path in "${MANAGED_SKILL_PATHS[@]}"; do
  rm -rf "$REPO_ROOT/$managed_path"
done
for name in "${SKILL_NAMES[@]}"; do
  cp -R "$PREPARED_DEST/$name" "$DEST/$name"
done

echo "Updated ${#SKILL_NAMES[@]} explicitly selected Matt Pocock skills in $DEST"
echo "Upstream commit: $UPSTREAM_COMMIT"
echo
echo "Review vendored skill changes before committing:"
git -C "$REPO_ROOT" status --short -- external/mattpocock-skills
git -C "$REPO_ROOT" --no-pager diff -- external/mattpocock-skills
