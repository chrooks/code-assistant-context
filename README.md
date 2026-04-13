# CodeAssistantContext

A portable context library for AI coding assistants (Claude Code, Cursor, etc.). Clone this repo on any machine to give your assistant consistent instructions, design standards, and project conventions across all your projects.

## Structure

```
user-level/     # Copy contents to ~/.claude/CLAUDE.md (global, applies to all projects)
project-level/  # Copy relevant files into a project's CLAUDE.md or context/ directory
```

## Usage

**Global defaults** — copy `user-level/CLAUDE.md` to `~/.claude/CLAUDE.md`. These apply to every project on the machine.

**Per-project context** — copy files from `project-level/` into your project as needed:

| File | Purpose |
|------|---------|
| `USE_DESIGN_CONTEXT.md` | Paste into a project's `CLAUDE.md` to activate design guidance |
| `design-principles.md` | S-tier SaaS design checklist (layout, components, interactions) |
| `ui-ux-style-guide-reference.md` | Template for generating a project-specific `style-guide.md` |

## Typical Setup for a New Project

1. Add `USE_DESIGN_CONTEXT.md` contents to the project's `CLAUDE.md`
2. Create a `context/design-principles.md` (copy from here)
3. Generate a `context/style-guide.md` using `ui-ux-style-guide-reference.md` as the template, filled in with project-specific values

## Learning System Setup

Skills and hooks for the Claude Code learning system (mode switching + knowledge capture):

**Install skills** (copy to `~/.claude/commands/`):
```bash
cp user-level/skills/mode/SKILL.md ~/.claude/commands/mode.md
cp user-level/skills/capture/SKILL.md ~/.claude/commands/capture.md
cp user-level/skills/sync-knowledge/SKILL.md ~/.claude/commands/sync-knowledge.md
```

**Install hooks** (copy to `~/.claude/hooks/`):
```bash
cp user-level/hooks/knowledge-sync.sh ~/.claude/hooks/
cp user-level/hooks/session-mode-loader.sh ~/.claude/hooks/
cp user-level/hooks/session-mode-cleanup.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/knowledge-sync.sh ~/.claude/hooks/session-mode-loader.sh ~/.claude/hooks/session-mode-cleanup.sh
```

**Configure vault** (copy template and set your path):
```bash
cp user-level/hooks/knowledge-config.json.template ~/.claude/knowledge-config.json
# Edit vaultPath to your Obsidian vault location
```

**Wire up `~/.claude/settings.json`**:
```json
{
  "hooks": {
    "SessionStart": [{ "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/session-mode-loader.sh" }] }],
    "PostToolUse": [{ "matcher": "Write", "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/knowledge-sync.sh" }] }]
  }
}
```

**Usage:**
- `/mode socratic` — Socratic learning mode (ask guiding questions instead of answering directly)
- `/mode annotator` — Annotator mode (annotates every architectural decision with prose explanations)
- `/mode standard` — Default behavior
- `/mode <mode> --persist` — Persist mode across sessions
- `/capture "concept name"` — Save a concept to `<project>/knowledge/<concept>.md` + sync to vault
- `/sync-knowledge` — Manually sync all knowledge files to vault

**Dependency:** `jq` must be installed (`brew install jq`).

