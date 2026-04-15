---
name: harness-knowledge-discovery
description: Use when starting work on a new project or major refactor and you must determine what knowledge docs an Agent needs to work stably on complex tasks
---

# Harness Knowledge Discovery

## Overview

Analyze a project's source code, directory structure, configuration files, and all available resources to generate a customized knowledge base blueprint — the list of `docs/` files an Agent needs to work stably and autonomously on complex tasks for that specific project.

**Core principle:** Different project types need different knowledge docs. Discover what's missing, don't just extract what exists.

## When to Use

- Starting work on a project with no existing Harness docs
- Project undergoes major architecture change (existing docs may be stale)
- Agent repeatedly fails on complex tasks due to missing context
- User asks "what docs should I create for this project?"

Do not use for:
- One-off questions about a single file
- Projects that already have a complete `docs/harness/` directory

## Core Pattern

### 1. Scan Project Structure

Read these files to understand the project:

| File/Pattern | What It Reveals |
|---|---|
| `package.json`, `pom.xml`, `go.mod`, `Cargo.toml`, etc. | Language, framework, dependencies |
| Directory layout | Architecture pattern (MVC, microservices, monorepo, etc.) |
| Config files (`.eslintrc`, `pyproject.toml`, `tsconfig.json`, etc.) | Coding constraints, tooling |
| `README.md`, `docs/` | Existing documentation, project goals |
| Test directory | Testing strategy, quality bar |
| CI/CD configs | Deployment constraints, quality gates |

### 2. Identify Project Type

Classify the project into one of these categories (or create a custom one):

| Project Type | Indicators |
|---|---|
| Frontend web | React, Vue, Angular, HTML/CSS/JS focus |
| Backend Java | Spring Boot, Maven/Gradle, Java packages |
| Node.js service | Express, Fastify, Node, API routes |
| Python service | Django, Flask, FastAPI, Python packages |
| CLI tool | Command entry points, arg parsing, no server |
| Full-stack | Both frontend and backend code present |
| Microservice | Single-purpose service, lightweight, containerized |
| Library/SDK | No entry point, exports, public API |
| Data/ML | Training scripts, data pipelines, model code |
| Mobile | React Native, Flutter, Swift, Kotlin |

### 3. Infer Knowledge Gaps

For each project type, check what docs exist and what's missing:

**Always needed:**
- [ ] Agent guidance file (`CLAUDE.md` or `AGENTS.md`) — auto-loaded at session start, contains the full Harness index
- [ ] Tech stack spec (`docs/harness/project-architecture.md`)
- [ ] Coding rules (`docs/rules/` — see `docs/rules/index.md` for index)
- [ ] Pre-task checklist (`docs/checklists/pre-task.md`)
- [ ] Code review checklist (`docs/checklists/code-review.md`)
- [ ] Post-task checklist (`docs/checklists/post-task.md`)

**Commonly needed by type:**

| Project Type | Additional Docs Needed |
|---|---|
| Frontend | Component patterns, state management rules, build config |
| Backend Java | API design rules, database conventions, service layer patterns |
| Node.js | API routing, error handling, middleware conventions |
| Python | Testing strategy, packaging, async patterns |
| Full-stack | API contract, data flow between layers, deployment |
| CLI | Output format, error exit codes, help text conventions |
| Microservice | Service communication, health checks, container config |

**For each missing doc, explain WHY it's needed:**
- What failure does it prevent?
- What decision does it enable?
- What context does it provide?

### 4. Output Knowledge Base Blueprint

Write the blueprint to `docs/harness/knowledge-blueprint.md`:

```markdown
# Knowledge Base Blueprint

Generated: YYYY-MM-DD
Project Type: [identified type]

## Existing Docs
- [path] — [purpose]

## Missing Docs (Recommended)
- [path] — [why needed: what failure it prevents]

## Missing Docs (Optional)
- [path] — [why useful]

## Project-Specific Notes
- [architecture observation]
- [tech stack constraint]
- [unusual pattern found]
```

### 5. Create initial agent guidance file (CLAUDE.md / AGENTS.md)

After generating the blueprint, create the project's agent guidance file. This file is auto-loaded by Cursor (AGENTS.md) and Claude Code (CLAUDE.md) at session start, so it MUST contain the full Harness index — not just a reference to another file.

**Determine which file(s) to create/update:**

1. If `CLAUDE.md` exists and `AGENTS.md` is a symlink to `CLAUDE.md`: update only `CLAUDE.md`
2. If both `CLAUDE.md` and `AGENTS.md` exist as independent files (not linked): update both files with the same content
3. If only `CLAUDE.md` exists: update it, then create `AGENTS.md` as a symlink to `CLAUDE.md`
4. If only `AGENTS.md` exists: update it, then create `CLAUDE.md` as a symlink to `AGENTS.md`
5. If neither exists: create `CLAUDE.md` with the full Harness index content, then create `AGENTS.md` as a symlink to `CLAUDE.md`

**File content format (for scenario 5 — neither exists):**

```markdown
# Project Guidelines

## Project Overview

**Type:** [identified project type]
**Tech Stack:** [key technologies]
**Working Directory:** [if applicable]

## Core Index

| When you need... | Read |
|---|---|
| Project coding standards | `docs/rules/index.md` |
| Project architecture & tech stack | `docs/harness/project-architecture.md` |
| Handle test failures | `docs/memory/failure-patterns.md` |
| Start a new task | `docs/checklists/pre-task.md` |
| Review code | `docs/checklists/code-review.md` |
| Complete a task | `docs/checklists/post-task.md` |
| Log execution evidence | `docs/memory/execution-log/` |

## Scenario Trigger Rules

- **New feature** → read `docs/rules/*.md` + `docs/checklists/pre-task.md`
- **Bugfix** → read `docs/memory/failure-patterns.md` + relevant `docs/rules/*.md`
- **Debugging** → read `docs/memory/failure-patterns.md`
- **Refactoring** → read `docs/checklists/code-review.md` + `docs/rules/*.md`
- **Code review** → read `docs/checklists/code-review.md` + `docs/rules/*.md`
- **Task complete** → execute `docs/checklists/post-task.md` + write to `docs/memory/execution-log/`

## Rules Sub-Index

| Rule Type | File |
|---|---|
| (populated by project-standards-authoring) | `docs/rules/` |

<!-- BEGIN standards-index -->
<!-- END standards-index -->
```

**If the file already exists** with `<!-- BEGIN standards-index -->` and `<!-- END standards-index -->` markers: replace content between markers with the new index block. Do not overwrite other content.

**If the file already exists** but markers are not found: append the full Harness index section at the end.

**Never delete existing content** unless replacing between markers.

Then create the symlink (if needed):
```bash
ln -s CLAUDE.md AGENTS.md
```

**CRITICAL:** Do NOT create a separate `agent.md` file. All Harness index content goes directly in `CLAUDE.md`/`AGENTS.md`. The `agent.md` filename is obsolete — the auto-loaded files ARE the index.

### 6. Create initial directory structure

Create any missing directories needed by the Harness environment:

- `docs/harness/` (if not exists)
- `docs/memory/execution-log/` (if not exists)
- `docs/checklists/` (if not exists)

Create placeholder files for missing memory docs if they don't exist:
- `docs/memory/failure-patterns.md` — with the "No patterns recorded yet" message and pattern format template
- `docs/memory/success-patterns.md` — with the "No patterns recorded yet" message and pattern format template

Do NOT create rules or checklists here — those are generated by `project-standards-authoring`.

## Collaboration with project-standards-authoring

Run `harness-knowledge-discovery` first to get the blueprint. Then run `project-standards-authoring` to fill in specific rule content for each recommended doc.

## Common Mistakes

- **Only extracting existing rules** — this skill infers missing docs, not just what already exists
- **Generic blueprints** — every project is different; tailor the output
- **Skipping the "why"** — each recommended doc must explain what failure it prevents
- **Over-recommending** — recommend only docs that address real gaps; YAGNI applies
- **Creating a separate `agent.md` file** — all index content goes in `CLAUDE.md`/`AGENTS.md` which are auto-loaded
- **Not creating CLAUDE.md/AGENTS.md** — the agent guidance file auto-loads at session start; without it agents see nothing
- **Not creating placeholder memory files** — failure-patterns.md and success-patterns.md must exist for the feedback loop to work
- **Creating rules or checklists here** — those are generated by `project-standards-authoring`, not by this skill

## Red Flags

- You listed docs that already exist in the project
- You didn't read config files to understand constraints
- You recommended the same docs for every project type without differentiation
- The blueprint has no project-specific notes
- You created a separate `agent.md` file instead of putting index content in `CLAUDE.md`/`AGENTS.md`
- You created rules files here instead of deferring to `project-standards-authoring`
- You didn't create `docs/memory/` placeholder files
- You didn't ensure `CLAUDE.md` and `AGENTS.md` exist with the full Harness index content

All red flags mean: re-scan the project, check what actually exists, and tailor recommendations.
