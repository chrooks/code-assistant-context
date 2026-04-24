#!/usr/bin/env bash

# Creates Codex-compatible project structure from .claude/ source.
#
# Mapping:
#   .claude/CLAUDE.md       -> AGENTS.md (repo root)
#   .claude/skills/         -> .agents/skills/
#   .claude/commands/       -> skipped (no Codex equivalent)
#   .claude/hooks/          -> skipped (no Codex equivalent)
#   .claude/settings.*.json -> skipped (Codex uses .codex/config.toml)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/.claude"

log() {
  printf '%s\n' "$*"
}

# Rewrite text references from Claude conventions to Codex conventions.
rewrite_content() {
  local source="$1"

  sed \
    -e 's/\.claude/.codex/g' \
    -e 's/CLAUDE\.md/AGENTS.md/g' \
    -e 's/claude/codex/g' \
    -e 's/Claude/Codex/g' \
    "$source"
}

# Copy a file with content rewriting, skipping if unchanged.
copy_rewritten() {
  local source="$1"
  local target="$2"
  local display_target="$3"
  local tmp_file

  tmp_file="$(mktemp "${TMPDIR:-/tmp}/create-codex-dir.XXXXXX")"

  rewrite_content "$source" > "$tmp_file"

  if [ -f "$target" ] && cmp -s "$tmp_file" "$target"; then
    rm -f "$tmp_file"
    log "Unchanged ${display_target}"
    return
  fi

  local verb="Copying"
  [ -f "$target" ] && verb="Updating"

  log "${verb} ${source#${REPO_ROOT}/} -> ${display_target}"

  mkdir -p "$(dirname "$target")"
  mv "$tmp_file" "$target"

  if [ -x "$source" ]; then
    chmod 755 "$target"
  else
    chmod 644 "$target"
  fi
}

main() {
  if [ ! -d "$SOURCE_DIR" ]; then
    log "Error: source directory not found: $SOURCE_DIR" >&2
    exit 1
  fi

  log "Creating Codex project structure from .claude/"

  # 1. CLAUDE.md -> .agents/AGENTS.md
  local agents_root="${REPO_ROOT}/.agents"
  mkdir -p "$agents_root"

  if [ -f "${SOURCE_DIR}/CLAUDE.md" ]; then
    copy_rewritten \
      "${SOURCE_DIR}/CLAUDE.md" \
      "${agents_root}/AGENTS.md" \
      ".agents/AGENTS.md"
  fi

  # 2. Skills -> .agents/skills/ (each skill is a subdirectory with SKILL.md)
  local skills_dir="${SOURCE_DIR}/skills"
  local agents_dir="${agents_root}/skills"

  if [ -d "$skills_dir" ]; then
    mkdir -p "$agents_dir"
    log "Creating .agents/skills/"

    # Walk skill subdirectories (each contains SKILL.md + optional files)
    while IFS= read -r skill_dir; do
      local skill_name
      skill_name="$(basename "$skill_dir")"
      local target_skill_dir="${agents_dir}/${skill_name}"
      mkdir -p "$target_skill_dir"

      # Copy all files within the skill directory
      while IFS= read -r skill_file; do
        local rel_file="${skill_file#${skill_dir}/}"
        copy_rewritten \
          "$skill_file" \
          "${target_skill_dir}/${rel_file}" \
          ".agents/skills/${skill_name}/${rel_file}"
      done < <(find "$skill_dir" -type f -print | LC_ALL=C sort)
    done < <(find "$skills_dir" -mindepth 1 -maxdepth 1 -type d -print | LC_ALL=C sort)
  fi

  # 3. Log skipped directories
  for skipped in commands hooks; do
    if [ -d "${SOURCE_DIR}/${skipped}" ]; then
      log "Skipping .claude/${skipped}/ (no Codex equivalent)"
    fi
  done

  if ls "${SOURCE_DIR}"/settings*.json 1>/dev/null 2>&1; then
    log "Skipping .claude/settings*.json (Codex uses .codex/config.toml)"
  fi

  # 4. Copy PLAN.md if present
  if [ -f "${SOURCE_DIR}/PLAN.md" ]; then
    copy_rewritten \
      "${SOURCE_DIR}/PLAN.md" \
      "${agents_root}/PLAN.md" \
      ".agents/PLAN.md"
  fi

  log "Done."
}

main "$@"
