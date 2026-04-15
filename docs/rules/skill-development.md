# Skill Development Standards

## Rule Objective

Ensure all skills follow consistent structure, naming conventions, and quality gates. Skills are code that shapes agent behavior — not prose.

## When to Use

- Creating a new skill (new `skills/<name>/SKILL.md`)
- Modifying an existing skill's content
- Reviewing a skill for quality or consistency

## Out of Scope

- Project-specific conventions (belong in CLAUDE.md)
- One-off scripts or utilities (belong in `scripts/`)
- Domain-specific plugins (belong in standalone plugins)

---

## Sources

| Source | Path |
|--------|------|
| Writing Skills skill | `skills/writing-skills/SKILL.md` |
| Skill directory structure | `skills/` (all 19 skills) |
| Agent Skill spec | [agentskills.io/specification](https://agentskills.io/specification) |
| CSO guidelines | `skills/writing-skills/SKILL.md` (Claude Search Optimization section) |

---

## Must (enforced by quality gates)

### SKILL-1: Iron Law — No skill without writing-skills
**Rule:** Any creation, modification, or deletion of `skills/**/SKILL.md` MUST use the `superpowers:writing-skills` TDD workflow. Direct edits are forbidden.
**Source:** `CLAUDE.md` line 69
**Evidence:** CLAUDE.md 明确写入 "IRON LAW: No skill creation, modification, or deletion without using `superpowers:writing-skills`"

### SKILL-2: YAML frontmatter required
**Rule:** Every SKILL.md MUST have YAML frontmatter with `name` and `description` fields. Max 1024 characters total.
**Source:** `skills/writing-skills/SKILL.md` lines 95-103

### SKILL-3: Description = when to use, NOT what it does
**Rule:** Frontmatter `description` MUST start with "Use when..." and describe ONLY triggering conditions. MUST NOT summarize the skill's process or workflow.
**Source:** `skills/writing-skills/SKILL.md` lines 150-172

### SKILL-4: Flat directory structure
**Rule:** All skills live in `skills/<skill-name>/SKILL.md`. No nested subdirectories or grouped folders.
**Source:** `skills/writing-skills/SKILL.md` lines 72-92, actual structure: `skills/writing-skills/SKILL.md`

### SKILL-5: Naming convention
**Rule:** Skill names MUST use `kebab-case` with only letters, numbers, and hyphens. Use active voice, verb-first (e.g., `creating-skills` not `skill-creation`).
**Source:** `skills/writing-skills/SKILL.md` lines 209-276

### SKILL-6: Structure follows SKILL.md template
**Rule:** Every SKILL.md MUST include: Overview, When to Use, Core Pattern/Quick Reference, Common Mistakes, Red Flags.
**Source:** `skills/writing-skills/SKILL.md` lines 93-137

### SKILL-7: Token efficiency
**Rule:** Skills loaded into every conversation (getting-started, frequently-referenced) MUST stay under 200 words. Other skills under 500 words.
**Source:** `skills/writing-skills/SKILL.md` lines 213-266

### SKILL-8: One excellent example
**Rule:** If examples are included, provide ONE complete, runnable example in the most relevant language. Do NOT implement in 5+ languages or create fill-in-the-blank templates.
**Source:** `skills/writing-skills/SKILL.md` lines 324-345

---

## Should (recommended)

### SKILL-9: Cross-references use skill name only
**Rule:** Reference other skills by name only (e.g., `superpowers:test-driven-development`). Do NOT use `@path` syntax which force-loads files.
**Source:** `skills/writing-skills/SKILL.md` lines 280-286

### SKILL-10: Red Flags table present
**Rule:** Discipline-enforcing skills MUST include a Red Flags table with Excuse/Reality columns and a STOP instruction.
**Source:** `skills/writing-skills/SKILL.md` lines 459-523

### SKILL-11: Flowcharts only for non-obvious decisions
**Rule:** Use dot flowcharts ONLY for non-obvious decision points. Never for reference material, code examples, or linear instructions.
**Source:** `skills/writing-skills/SKILL.md` lines 290-316

---

## Must Avoid (anti-patterns)

### SKILL-12: Narrative storytelling
**Rule:** Do NOT write "In session 2025-10-03, we found..." Skills are reusable techniques, not narratives.
**Source:** `skills/writing-skills/SKILL.md` lines 564-566

### SKILL-13: Multi-language dilution
**Rule:** Do NOT create example-js.js, example-py.py, example-go.go. One excellent example is enough.
**Source:** `skills/writing-skills/SKILL.md` lines 568-570

### SKILL-14: Batch skill creation
**Rule:** Do NOT create multiple skills in batch without testing each. Deploy one, test, then move to next.
**Source:** `skills/writing-skills/SKILL.md` lines 583-594
