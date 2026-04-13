# Project Standards Authoring - Document Templates

Replace `${type}` with the English `kebab-case` code type name. Fill from repository evidence only.

---

## 1) Rules - `docs/rules/${type}.md`

```markdown
Path: docs/rules/${type}.md

---
description: Project standards for ${type}
globs:
  - "**/${type}/**"
alwaysApply: false
---

# ${type} - Project Rules

## Rule Objective
- What this ruleset protects:
-

## When to Use
- Apply this ruleset when:
-

## Out of Scope
- Do not apply this ruleset when:
-

## Scope
- What this type covers (paths, modules, boundaries):
-

## Must
- [Testable or reviewable rule] (Sources: `path/or/file`)

## Must Not
- [Forbidden pattern] (Sources: `path/or/file`)

## Naming & Structure
- [Convention] (Sources: `path/or/file`)

## Verification
- [Checks, tests, or review steps agents must run or satisfy]

## Sources
- `path/or/file` - [what evidence was taken from it]
```

Constraints:

- Each rule MUST map to at least one source path in `Sources`.
- Ban soft language without operational meaning (for example: "keep it elegant").
- Rules are incomplete without `Rule Objective`, `When to Use`, and `Out of Scope`.

Chinese header variant (when user requests Chinese prose):

```markdown
## 规则目标
- 该规则集要保护什么:
-

## 何时使用
- 适用场景:
-

## 不适用范围
- 以下场景不应用本规则集:
-
```

---

## 2) Checklist - `docs/checklist/${type}.md`

```markdown
# ${type} - Checklist

## Before Design
- [ ] Action-oriented item tied to a Must rule (rule ref: Must #)

## During Implementation
- [ ] ...

## Before Commit
- [ ] ...

## Stop-Ship
- [ ] ...
```

Constraints:

- Items MUST be checkable (observable outcome, command, or review gate).
- Every `Must` rule in `docs/rules/${type}.md` MUST appear in at least one checklist item (reference rule id or quote the Must line).

---

## 3) How to create - `docs/guides/how-to-create-${type}.md` (conditional)

```markdown
# How to Create: ${type}

## When to Create This Type
-

## Minimum Module Skeleton
- Files/directories to create:
-

## Dependencies and Boundaries
- Allowed dependencies:
- Forbidden dependencies / coupling:

## Common Failure Modes
-

## Minimum Verification Path
- Commands or checks:
```

Constraint:

- Focus on how to create this module type. Do NOT paste the full rules document; link or point to `docs/rules/${type}.md` instead.

---

## 4) Reuse inventory - `docs/resources/reuse-inventory.md` (global)

```markdown
# Reuse Inventory

## Inventory Table

| Name | Kind | Location | Reusable For | When Not To Reuse |
|------|------|----------|--------------|-------------------|
| | module/component/function/utility/class/etc. | `path` | | |

## Cross-Module Hotspots
- High-value reusable assets (name, location, reuse boundary):

```

Constraints:

- Every row MUST include a concrete `Location` path.
- `When Not To Reuse` MUST be explicit (misuse risks, coupling traps).
