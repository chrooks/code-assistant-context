# CodeAssistantContext

A portable context library for AI coding assistants (Claude Code, Cursor, etc.). Clone this repo on any machine to give your assistant consistent instructions, design standards, and project conventions across all your projects.

## Structure

```
.claude/            # Drop directly into ~ to install user-level config
  CLAUDE.md         # Global instructions (applies to all projects)
  commands/         # Claude Code skills (/commit, /feature, /mode, etc.)
  hooks/            # Session hooks (mode loader, knowledge sync)
project-level/      # Copy relevant files into a project's CLAUDE.md or context/ directory
```

## Quick Install (User-Level)

```bash
cp -r .claude ~/
chmod +x ~/.claude/hooks/*.sh
```

Or symlink to keep it in sync with this repo:

```bash
ln -s "$(pwd)/.claude" ~/.claude
```

## Commands (Skills)

| Command | Description |
|---------|-------------|
| `/commit` | Stage and commit with a conventional commit message |
| `/feature <description>` | Full-cycle feature development: discovery → plan → TDD → review → commit |
| `/mode <socratic\|annotator\|standard>` | Switch learning mode for the session |
| `/capture <concept>` | Save a concept to the project knowledge base and sync to Obsidian |
| `/sync-knowledge` | Manually sync all knowledge files to Obsidian vault |
| `/handoff` | Generate a continuation prompt for the next session |

## Hooks

| Hook | Purpose |
|------|---------|
| `session-mode-loader.sh` | Restore persisted learning mode on session start |
| `session-mode-cleanup.sh` | Clear non-persisted mode on session end |
| `knowledge-sync.sh` | Auto-sync knowledge files to Obsidian vault on write |

## Configure Obsidian Vault Sync

```bash
cp ~/.claude/hooks/knowledge-config.json.template ~/.claude/knowledge-config.json
# Edit vaultPath to your Obsidian vault location
```

Wire up `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [{ "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/session-mode-loader.sh" }] }],
    "PostToolUse": [{ "matcher": "Write", "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/knowledge-sync.sh" }] }]
  }
}
```

**Dependency:** `jq` must be installed (`brew install jq`).

## Project-Level Context

Copy files from `project-level/` into a project as needed:

| File | Purpose |
|------|---------|
| `USE_DESIGN_CONTEXT.md` | Paste into a project's `CLAUDE.md` to activate design guidance |
| `context/design-principles.md` | S-tier SaaS design checklist (layout, components, interactions) |
| `context/ui-ux-style-guide-reference.md` | Template for generating a project-specific `style-guide.md` |

### Typical Setup for a New Project

1. Add `USE_DESIGN_CONTEXT.md` contents to the project's `CLAUDE.md`
2. Create `context/design-principles.md` (copy from here)
3. Generate `context/style-guide.md` using `ui-ux-style-guide-reference.md` as the template
