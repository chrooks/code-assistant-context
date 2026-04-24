#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/.claude"
TARGET_DIR="${REPO_ROOT}/.codex"

log() {
  printf '%s\n' "$*"
}

map_relative_path() {
  local path="$1"

  path="${path//.claude/.codex}"
  path="${path//CLAUDE.md/AGENTS.md}"
  path="${path//claude/codex}"
  path="${path//Claude/Codex}"

  printf '%s\n' "$path"
}

ensure_dir() {
  local dir="$1"

  if [ -d "$dir" ]; then
    log "Exists ${dir}"
    return
  fi

  mkdir -p "$dir"
  log "Creating ${dir}"
}

rewrite_file() {
  local source="$1"
  local target="$2"
  local display_target="$3"
  local tmp_file

  tmp_file="$(mktemp "${TMPDIR:-/tmp}/create-codex-dir.XXXXXX")"

  sed \
    -e 's/\.claude/.codex/g' \
    -e 's/CLAUDE\.md/AGENTS.md/g' \
    -e 's/claude/codex/g' \
    -e 's/Claude/Codex/g' \
    "$source" > "$tmp_file"

  if [ -f "$target" ] && cmp -s "$tmp_file" "$target"; then
    rm -f "$tmp_file"
    log "Unchanged ${display_target}"
    return
  fi

  if [ -f "$target" ]; then
    log "Updating ${source#${REPO_ROOT}/} -> ${display_target}"
  else
    log "Copying ${source#${REPO_ROOT}/} -> ${display_target}"
  fi

  mv "$tmp_file" "$target"

  if [ -x "$source" ]; then
    chmod 755 "$target"
  else
    chmod 644 "$target"
  fi
}

main() {
  local rel_dir
  local rel_file
  local target_rel
  local source_path
  local target_path
  local target_parent

  if [ ! -d "$SOURCE_DIR" ]; then
    log "Error: source directory not found: $SOURCE_DIR" >&2
    exit 1
  fi

  log "Mirroring .claude -> .codex"
  ensure_dir "$TARGET_DIR"

  while IFS= read -r rel_dir; do
    target_rel="$(map_relative_path "$rel_dir")"
    ensure_dir "${TARGET_DIR}/${target_rel}"
  done < <(
    find "$SOURCE_DIR" -mindepth 1 -type d -print |
      sed "s|^${SOURCE_DIR}/||" |
      LC_ALL=C sort
  )

  while IFS= read -r rel_file; do
    source_path="${SOURCE_DIR}/${rel_file}"
    target_rel="$(map_relative_path "$rel_file")"
    target_path="${TARGET_DIR}/${target_rel}"
    target_parent="$(dirname "$target_path")"

    ensure_dir "$target_parent"
    rewrite_file "$source_path" "$target_path" ".codex/${target_rel}"
  done < <(
    find "$SOURCE_DIR" -type f -print |
      sed "s|^${SOURCE_DIR}/||" |
      LC_ALL=C sort
  )
}

main "$@"
