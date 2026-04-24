# Development Guidelines

# ExecPlans
- When writing complex features or significant refactors, use an ExecPlan (as described in ~/.codex/PLAN.md) from design to implementation.

## Tech Stack

Primary languages and frameworks across projects:
- **Frontend**: TypeScript, React, Next.js
- **Backend**: Python (Flask/FastAPI), TypeScript (Node.js)
- **Database**: PostgreSQL (via Supabase)

For language-specific rules, import them in the project-level AGENTS.md:
- Python projects: `@~/.codex/rules/python/`
- TypeScript projects: `@~/.codex/rules/typescript/`

## Philosophy

### Core Beliefs

- **Incremental progress over big bangs** - Small changes that compile and pass tests
- **Learning from existing code** - Study and plan before implementing
- **Pragmatic over dogmatic** - Adapt to project reality
- **Clear intent over clever code** - Be boring and obvious

### Simplicity

- **Single responsibility** per function/class
- **Avoid premature abstractions**
- **No clever tricks** - choose the boring solution
- If you need to explain it, it's too complex

## Learning & Growth

The user is actively developing their software engineering knowledge. When explaining
or implementing anything non-trivial, prioritize understanding at the architectural
and design level over language-level detail.

### Explain Why Before How

When implementing or explaining a solution:
- **Lead with purpose** — why does this solution exist? What problem does it solve?
- **Name the pattern** — if the code uses a known pattern (task queue, producer-consumer,
  middleware, factory, etc.), name it, and briefly explain what makes it that pattern
- **Explain the shape** — why is the system structured this way? What would get harder
  or break with a different structure?
- **Skip the obvious** — assume fluency in the languages being used; don't explain
  syntax unless it's genuinely non-obvious or explicitly asked about

### Levels of Explanation (in priority order)

1. **Architectural** — how do systems fit together and why? (stateless servers, task
   queues, pre-computation caches, message brokers, event streams)
2. **Design** — how do components within a system relate? (dependency injection,
   middleware chains, factory functions, observer pattern)
3. **Implementation** — how is this specific thing built? (polling workers, connection
   pooling, JWT validation, DB transactions)
4. **Language/syntax** — only when explicitly asked or when a language feature
   is doing something genuinely non-obvious

## Technical Standards

### Architecture Principles

- **Composition over inheritance** - Use dependency injection
- **Interfaces over singletons** - Enable testing and flexibility
- **Explicit over implicit** - Clear data flow and dependencies
- **Test-driven when possible** - Never disable tests, fix them

### Error Handling

- **Fail fast** with descriptive messages
- **Include context** for debugging
- **Handle errors** at appropriate level
- **Never** silently swallow exceptions

## Project Integration

### Learn the Codebase

- Find similar features/components
- Identify common patterns and conventions
- Use same libraries/utilities when possible
- Follow existing test patterns

### Tooling

- Use project's existing build system
- Use project's existing test framework
- Use project's formatter/linter settings
- Don't introduce new tools without strong justification

### Code Style

- When writing frontend code (React, HTML, etc.) ALWAYS give elements id's that I, the human, can use to communicate to you with
- Follow existing conventions in the project
- Refer to linter configurations and .editorconfig, if present
- Text files should always end with an empty line

## Rules

@~/.codex/rules/common/coding-style.md
@~/.codex/rules/common/git-workflow.md
@~/.codex/rules/common/security.md
@~/.codex/rules/common/agents.md
@~/.codex/rules/common/development-workflow.md

## MCP Tool Use

- Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask

## Important Reminders

**NEVER**:
- Use `--no-verify` to bypass commit hooks
- Disable tests instead of fixing them
- Commit code that doesn't compile
- Make assumptions - verify with existing code

**ALWAYS**:
- Commit working code incrementally
- Update plan documentation as you go
- Learn from existing implementations
- Stop after 3 failed attempts and reassess