---
name: harness-feedback-loop
description: Use when completing any task and you must collect execution evidence, record failure or success patterns, and update the project memory
---

# Harness Feedback Loop

## Overview

Collect execution evidence after task completion. Compare expected vs actual results. Write failure/success patterns to `docs/memory/` for future reference.

**Core principle:** Every task execution teaches something. Capture it before the context is lost.

## When to Use

- After completing any implementation task
- When a task failed or deviated from the plan
- When a task succeeded in a notable or reusable way
- At the end of each work session (minimum)

Do not use for:
- Mid-task status updates
- Planning or design discussions

## Core Pattern

### 1. Compare Planned vs Actual

| Question | How to Answer |
|---|---|
| What was the task goal? | Read the task description or plan |
| What was actually delivered? | Review the output (code, docs, tests) |
| Did it match? | Yes / No / Partially |
| What deviated? | List specific differences |

### 2. Classify the Outcome

| Outcome | Action |
|---|---|
| **Success, standard** | Write brief execution log entry |
| **Success, notable pattern** | Write to `success-patterns.md` + execution log |
| **Failure or deviation** | Write to `failure-patterns.md` + execution log |
| **Partial success** | Write both (what worked + what didn't) |

### 3. Write Execution Log

Append to `docs/memory/execution-log/YYYY-MM-DD.md`:

```markdown
## Task: [Task Name]
- **Time**: HH:MM
- **Outcome**: success | failure | partial
- **Planned**: [what was supposed to happen]
- **Actual**: [what actually happened]
- **Deviation**: [if any, describe]
- **Lesson**: [one sentence takeaway]
```

### 4. Update Pattern Libraries

**For failures**, append to `docs/memory/failure-patterns.md`:

```markdown
## [Pattern Name]
- **Trigger Condition**: When...
- **Symptom**: ...
- **Root Cause**: ...
- **Resolution**: ...
- **First Recorded**: YYYY-MM-DD
- **Occurrence Count**: N
```

If the pattern already exists, increment the occurrence count instead of duplicating.

**For notable successes**, append to `docs/memory/success-patterns.md`:

```markdown
## [Pattern Name]
- **Context**: What was being attempted...
- **What Worked**: The approach that succeeded...
- **Key Factors**: Why it worked...
- **Reusable Template**: How to apply again...
- **First Recorded**: YYYY-MM-DD
- **Reuse Count**: N
```

## Quick Reference: When to Write Which File

| Situation | Write To |
|---|---|
| Task completed normally | `execution-log/YYYY-MM-DD.md` only |
| Task succeeded with reusable approach | `success-patterns.md` + execution log |
| Task failed or deviated | `failure-patterns.md` + execution log |
| Recurring failure (same pattern) | Increment occurrence count, don't duplicate |
| New type of failure | New entry in `failure-patterns.md` |

## Common Mistakes

- **Writing execution logs without classification** — always answer: did it match the plan?
- **Duplicating existing patterns** — check if the pattern already exists before adding
- **Vague entries** — "something went wrong" is not useful; be specific about trigger, symptom, root cause
- **Skipping the log for standard successes** — the log tracks volume and velocity too

## Red Flags

- You didn't compare planned vs actual before writing
- You wrote "no lessons learned" for every task (that's unlikely)
- Your failure entry lacks a root cause analysis
- You're writing patterns mid-task (wait until task is complete)

All red flags mean: stop, review the entry format, and rewrite the entry properly.
