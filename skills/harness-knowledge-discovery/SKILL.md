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
- [ ] Tech stack spec (`docs/harness/project-architecture.md`)
- [ ] Coding rules (`docs/rules/`)
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

## Collaboration with project-standards-authoring

Run `harness-knowledge-discovery` first to get the blueprint. Then run `project-standards-authoring` to fill in specific rule content for each recommended doc.

## Common Mistakes

- **Only extracting existing rules** — this skill infers missing docs, not just what already exists
- **Generic blueprints** — every project is different; tailor the output
- **Skipping the "why"** — each recommended doc must explain what failure it prevents
- **Over-recommending** — recommend only docs that address real gaps; YAGNI applies

## Red Flags

- You listed docs that already exist in the project
- You didn't read config files to understand constraints
- You recommended the same docs for every project type without differentiation
- The blueprint has no project-specific notes

All red flags mean: re-scan the project, check what actually exists, and tailor recommendations.
