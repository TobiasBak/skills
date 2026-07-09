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

git clone --depth 1 --filter=blob:none --sparse https://github.com/mattpocock/skills "$TMP/repo"
git -C "$TMP/repo" sparse-checkout set --no-cone '/skills/engineering/*' '/skills/productivity/*'

mapfile -t UPSTREAM_SKILL_DIRS < <(
  find "$TMP/repo/skills/engineering" "$TMP/repo/skills/productivity" \
    -mindepth 2 -maxdepth 2 -type f -name SKILL.md -printf '%h\n' |
    sed "s#^$TMP/repo/##" |
    sort -u
)

if [ "${#UPSTREAM_SKILL_DIRS[@]}" -eq 0 ]; then
  echo "No engineering or productivity skills found upstream." >&2
  exit 1
fi

declare -A NAME_TO_UPSTREAM=()
for upstream_dir in "${UPSTREAM_SKILL_DIRS[@]}"; do
  name="$(basename "$upstream_dir")"
  if [[ -n "${NAME_TO_UPSTREAM[$name]:-}" ]]; then
    echo "Duplicate upstream skill name '$name': ${NAME_TO_UPSTREAM[$name]}, $upstream_dir" >&2
    exit 1
  fi
  NAME_TO_UPSTREAM["$name"]="$upstream_dir"
done

mapfile -t SKILL_NAMES < <(printf '%s\n' "${!NAME_TO_UPSTREAM[@]}" | sort)

CURRENT_SKILL_PATHS=()
while IFS= read -r -d '' skill_dir; do
  CURRENT_SKILL_PATHS+=("external/mattpocock-skills/$(basename "$skill_dir")")
done < <(find "$DEST" -mindepth 1 -maxdepth 1 -type d -print0)

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

find "$DEST" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +

for name in "${SKILL_NAMES[@]}"; do
  cp -R "$TMP/repo/${NAME_TO_UPSTREAM[$name]}" "$DEST/$name"
done

echo "Updated ${#SKILL_NAMES[@]} Matt Pocock engineering and productivity skills in $DEST"
echo
echo "Review vendored skill changes before committing:"
git -C "$REPO_ROOT" status --short -- external/mattpocock-skills
git -C "$REPO_ROOT" --no-pager diff -- external/mattpocock-skills
