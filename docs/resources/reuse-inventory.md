# Reuse Inventory

> Global inventory of reusable patterns, templates, and conventions in this project.

## Skill Templates

| Template | Location | Description |
|----------|----------|-------------|
| SKILL.md structure | `skills/writing-skills/SKILL.md` | YAML frontmatter + Overview + When to Use + Core Pattern + Red Flags |
| Frontmatter pattern | `skills/writing-skills/SKILL.md` lines 95-109 | `name` + `description` fields, max 1024 chars |
| Rationalization Table | `skills/writing-skills/SKILL.md` lines 444-457 | Excuse/Reality format for discipline enforcement |
| Red Flags Table | `skills/writing-skills/SKILL.md` lines 497-523 | Excuse/Reality + STOP instruction |

## Testing Conventions

| Convention | Location | Description |
|------------|----------|-------------|
| Test script structure | `tests/claude-code/test-harness-environment.sh` | PASS/FAIL output format, exit codes, ROOT resolution |
| Check function pattern | `tests/claude-code/test-harness-environment.sh` | Reusable `check()` function with description + condition |
| Validation reports | `docs/testing-reports/` | Store test output per skill per harness |

## Hook Patterns

| Pattern | Location | Description |
|---------|----------|-------------|
| Post-task hook | `.cursor/hooks/harness-post-task.sh` | Exit 0 if precondition not met, append to execution log |
| Platform-agnostic | Both `.cursor/` and `.claude/` | Same script works on Cursor and Claude Code |

## Documentation Conventions

| Convention | Location | Description |
|------------|----------|-------------|
| Rules structure | `docs/rules/*.md` | Rule Objective + When to Use + Out of Scope + Sources + Must/Should/Must Avoid |
| Checklist structure | `docs/checklists/*.md` | Categorized checkboxes with context header |
| Design doc path | `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` | Design documents |
| Plan doc path | `docs/superpowers/plans/YYYY-MM-DD-<topic>-plan.md` | Implementation plans |
