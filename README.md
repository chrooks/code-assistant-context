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

