---
name: real-world-skill-validation
description: Use when validating a skill in real project tasks and collecting structured execution evidence for iterative skill optimization.
---

# Real-World Skill Validation

## Overview

Validate a skill with real tasks, capture evidence automatically, and feed concrete failures back into the skill.

Core principle: no "skill optimization" claim without transcript-backed evidence from real runs.

## Required Background

- **REQUIRED BACKGROUND:** Understand `superpowers:writing-skills`
- **REQUIRED BACKGROUND:** Understand `superpowers:test-driven-development`

## When to Use

Use this skill when:

- You want to verify a skill on real project work (feature, bugfix, refactor)
- You need auditable evidence instead of anecdotal feedback
- You are iterating a skill and want RED -> GREEN -> REFACTOR loops

Do not use this skill for:

- Pure reference skills that do not enforce behavior
- One-off demos with no follow-up optimization plan

## Iron Law

```
NO SKILL OPTIMIZATION WITHOUT REAL-RUN EVIDENCE
```

If you cannot point to transcript evidence, treat conclusions as unverified.

## Workflow

### 1) Define real scenarios

Pick at least 3 scenarios:

- Feature implementation
- Bug fix
- Refactor or behavior-preserving change

Each scenario should include real pressures (deadline, unfamiliar module, ambiguity).

### 2) Run baseline (RED)

Run scenarios without enforcing the target skill.

Capture:

- What the agent did
- Where it violated expected discipline
- Rationalizations quoted verbatim

### 3) Run with skill (GREEN)

Re-run equivalent scenarios with target skill explicitly required.

Expected upgrades:

- Explicit constraints or policy summary before implementation
- Source-backed decisions (not generic claims)
- Better verification and clearer compliance reporting

### 4) Close loopholes (REFACTOR)

If new rationalizations appear:

- Add explicit counters in the target skill
- Update rationalization table and red flags
- Re-run scenarios until behavior stabilizes

## Automated Collection (Recommended)

Use the built-in test and analyzer scripts in this repository:

```bash
cd tests/claude-code
./test-real-world-skill-validation.sh \
  --target-repo /absolute/path/to/real-project \
  --skill superpowers:standards-context-retrieval \
  --scenario feature
```

This produces:

- Raw run artifacts (prompt/output/session metadata)
- A structured markdown report for optimization

Run one report per scenario (`feature`, `bugfix`, `refactor`) and compare.

## Required Evidence Fields

Every run must record:

- Task type and pressure profile
- Whether target skill was invoked
- Whether required structure appears (for example constraints summary)
- Source traceability quality
- Verification outcome
- Rationalizations / failure modes
- Suggested skill changes

## Report-Driven Optimization

When updating the target skill, each edit must map to report evidence:

- Failing behavior in report -> counter-rule in skill
- Missing trigger in report -> description trigger update
- Ambiguous step in report -> explicit workflow wording

Do not add speculative rules not observed in reports.

## Red Flags - Stop and Re-run

- "Looks good" with no report file
- No transcript/session linkage
- Skill updated without evidence mapping
- Only one scenario tested
- Time pressure used as reason to skip evidence

All red flags mean: re-run with evidence collection enabled.

## Quick Checklist

- [ ] 3+ real scenarios selected
- [ ] RED baseline evidence captured
- [ ] GREEN run evidence captured
- [ ] New loopholes documented and patched
- [ ] Optimization changes mapped to evidence
