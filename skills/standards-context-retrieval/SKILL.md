---
name: standards-context-retrieval
description: Use when implementing, fixing, or refactoring code in this repository and you must identify project-specific standards before writing code, especially under time pressure or in unfamiliar modules.
---

# Standards Context Retrieval

## Overview

Retrieve project standards before implementation, then generate code under explicit constraints.

Core principle: local standards beat generic defaults. If standards are not retrieved first, implementation quality is untrusted.

## Iron Law

```
NO IMPLEMENTATION BEFORE AN EXPLICIT CONSTRAINTS SUMMARY
```

If you did not produce an explicit Constraints Summary first, stop and restart.

No exceptions:
- Do not use "mental checklist only"
- Do not claim "I will follow conventions" without listing them
- Do not defer standards retrieval until after writing code

## When to Use

Use this skill before writing implementation when any of these are true:

- The request involves adding or modifying code behavior
- The task spans unfamiliar modules or languages
- The user asks to follow "project conventions", "spec", "style", or "rules"
- The task likely touches architecture, testing, or safety constraints
- You feel pressure to "ship quickly first, clean up standards later"

Do not use this skill for:

- Pure explanation requests with no code changes
- Non-code tasks (meeting notes, translation, etc.)

## Required Workflow

### 1) Identify code type and scope

Determine the most likely implementation surface:

- Language: TypeScript/JavaScript, Python, Shell, Markdown-heavy docs, etc.
- Layer: CLI, skill docs, tests, scripts, hooks, core runtime
- Change kind: feature, bugfix, refactor, tests-only, docs-only

If uncertain, scan target files first and infer from nearby patterns.

For refactor requests framed as "align with project standards", also classify:

- Business page type (list/detail/workbench/form/wizard, etc.)
- Naming semantics expected by that type
- Whether existing naming/layout is carrying wrong semantics

### 2) Retrieve standards in strict priority order

Gather standards from highest-authority to local conventions:

1. User instruction in current conversation
2. Repository rules and agent guidance files
3. Skill-specific/process docs under `docs/` and `skills/`
4. Test and quality docs (testing strategy, validation workflow)
5. Existing nearby code patterns in the target module

Prefer concrete, enforceable guidance over broad style advice.

### 3) Build an explicit Constraints Summary (mandatory gate)

Create a short "Constraints Summary" before implementation with:

- Required behavior constraints
- Testing/verification constraints
- File/path conventions
- Prohibited patterns and anti-patterns

Only include constraints supported by retrieved sources.
If no sources are found for a category, write "none found" explicitly.

When the user provides runtime evidence (screenshots/logs/repro steps), add an "Observed Runtime Facts" subsection and treat those facts as mandatory constraints for diagnosis and verification.

### 4) Implement against constraints

While coding, actively check each change against the summary:

- Does naming/path/layout match local conventions?
- Are required tests or verification steps included?
- Are any forbidden shortcuts being introduced?
- For refactors, do names and folder semantics match business intent (not just structural similarity)?

When constraints conflict, apply the priority order and state which source won.

### 5) Final compliance check

Before final response, provide a compact compliance report:

- Which constraints were applied
- Which files reflect those constraints
- Any constraints not applicable to this change

## Retrieval Strategy

Use narrow, high-signal retrieval first, then expand only if needed:

1. Start with exact file families relevant to code type
2. Search for policy words: "must", "required", "never", "always", "checklist"
3. Expand only if standards are missing or conflicting

## Quick Reference: Code Type -> High-Signal Sources

| Code Type | Read First | Then Read | Evidence Keywords |
|---|---|---|---|
| JS/TS runtime or CLI | `docs/**/*.md` on architecture/process | nearby module files + tests | must, required, cli, output, contract |
| Python scripts/tests | `docs/testing.md` | script/test neighbors | flaky, race, required, fixture |
| Shell hooks/scripts | `.cursor/hooks/*.sh` neighbors | docs mentioning hooks/workflows | before, after, guard, stop |
| Skill docs | `skills/**/SKILL.md` (relevant process skills) | `docs/testing.md` if verification claims exist | Use when, required, no exceptions |
| Unknown mixed scope | user instruction + repository rules | nearest code and tests | required, policy, checklist |

## Recommended Default Targets

- `docs/testing.md`
- `docs/**/*.md` where feature/process guidance exists
- `openspec/**/*.md` where feature/process guidance exists
- `specs/**/*.md` where feature/process guidance exists
- `skills/**/SKILL.md` for workflow constraints
- Top-level readmes and contributor guidance files

## Constraints Summary Template

Use this format before implementation:

```markdown
Constraints Summary
- Scope: <what is being changed>
- Code Type: <language/layer/change kind>
- Sources Consulted:
  - <path 1>
  - <path 2>
- Must Follow:
  - <constraint 1>
  - <constraint 2>
- Must Avoid:
  - <anti-pattern 1>
  - <anti-pattern 2>
- Observed Runtime Facts:
  - <fact from logs/screenshots/repro; write "none found" if none>
- Verification Required:
  - <tests/checks to run>
```

## Conflict Resolution

When sources disagree:

1. Follow explicit user instruction first
2. Then repository-level mandatory rules
3. Then domain/process docs
4. Then local code conventions

Document conflicts briefly and continue with the highest-priority rule.

## Fallback Behavior

If no relevant standards are found:

- Explicitly state: "No project-specific standard found for this code type."
- Use existing nearby code style and minimal-change strategy
- Avoid introducing new patterns unless required for correctness

Never fabricate project policy.

If standards are ambiguous for naming or structure, prefer business-semantic naming over generic placeholders (for example, avoid defaulting to `List`/`Form` when the page is not a list/form workflow).

## Rationalization Table

| Excuse | Reality |
|---|---|
| "I already know this repo style" | Memory is unreliable; retrieve current docs first. |
| "Time is short, I'll fix standards later" | Fast wrong code creates rework; constraints first reduces churn. |
| "Mental checklist is enough" | Non-explicit constraints are not auditable and are easy to skip. |
| "Generic best practices should be fine" | Local repository rules override generic defaults. |
| "I'll read standards after coding" | That is retrofitting, not standards-constrained implementation. |
| "This looks like a list-style refactor, I'll use List naming" | Structural pattern matching is not enough; naming must reflect business semantics. |
| "Dev mode works, so build/test environments should be fine" | Environment parity must be verified from build artifacts and target-mode execution. |

## Red Flags - Stop and Restart

- You started coding before writing Constraints Summary
- You cannot name the source file for a stated rule
- You only used generic guidance and no local sources
- You skipped verification constraints because of time pressure
- You wrote "follow project style" without listing concrete constraints
- You used generic `List`/`Form` naming without validating business semantics
- You claimed "fixed" from dev behavior only, without checking build/test artifacts when relevant

All red flags mean: stop, retrieve standards, rebuild Constraints Summary, then continue.

## Common Mistakes

- Starting implementation before retrieval
- Using only generic best practices and ignoring local docs
- Citing standards without mapping them to actual code changes
- Expanding retrieval too broadly and losing focus
- Treating "mental checklist" as equivalent to explicit constraints
- Overfitting to familiar page scaffolds and misnaming business components
- Validating only development mode for changes that affect chunking/lazy-loading/build outputs

## Quick Checklist

- [ ] Code type identified
- [ ] Relevant standards retrieved
- [ ] Constraints Summary written before implementation
- [ ] Implementation aligned with constraints
- [ ] Final compliance check reported
- [ ] Refactor naming/layout validated against business semantics
- [ ] If build/runtime-sensitive, verification includes non-dev artifacts or environment
