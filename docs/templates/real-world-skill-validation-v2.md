# Real-World Skill Validation Template (V2)

Use this template for one full validation campaign (RED + GREEN, then REFACTOR inputs).

## 1) Campaign Metadata

- Date:
- Owner:
- Target Skill:
- Validation Skill: `superpowers:real-world-skill-validation`
- Target Repository:
- Branch/Commit Range:
- Report Links:
  - RED report:
  - GREEN report:

## 2) Scope and Scenarios

List at least 3 real scenarios:

1. Feature:
2. Bugfix:
3. Refactor:

Pressure profile per scenario (time, unfamiliar module, risk, ambiguity):

- Scenario 1:
- Scenario 2:
- Scenario 3:

## 3) Prompt Control (Fairness Guard)

Use the same task prompt and acceptance criteria for RED and GREEN.
Only change one variable: skill enforcement.

- RED mode: no forced target skill
- GREEN mode: force target skill
- Other controls fixed:
  - Model/profile:
  - Allowed tools:
  - Time limit:
  - Repo state:

## 4) Pass/Fail Gate (Predefined)

Score each run with the same gate (0/1 each):

- [ ] Explicit `Constraints Summary` exists
- [ ] `Sources Consulted` includes concrete paths
- [ ] Constraints appear before implementation steps
- [ ] Compliance section exists
- [ ] Verification commands are explicit

Per-run score: `x/5`  
Suggested threshold:

- `4/5` or above: pass
- `<4/5`: fail

## 5) RED Results (Without Forced Skill)

### Scenario A

- Score:
- Outcome: pass/fail
- Evidence:
  - Session:
  - Report:
- Rationalizations (verbatim):
  - "..."

### Scenario B

- Score:
- Outcome: pass/fail
- Evidence:
  - Session:
  - Report:
- Rationalizations (verbatim):
  - "..."

### Scenario C

- Score:
- Outcome: pass/fail
- Evidence:
  - Session:
  - Report:
- Rationalizations (verbatim):
  - "..."

## 6) GREEN Results (Forced Skill)

### Scenario A

- Score:
- Outcome: pass/fail
- Evidence:
  - Session:
  - Report:
- Notable behavior upgrades:
  - ...

### Scenario B

- Score:
- Outcome: pass/fail
- Evidence:
  - Session:
  - Report:
- Notable behavior upgrades:
  - ...

### Scenario C

- Score:
- Outcome: pass/fail
- Evidence:
  - Session:
  - Report:
- Notable behavior upgrades:
  - ...

## 7) RED vs GREEN Summary

| Dimension | RED | GREEN | Delta |
|---|---|---|---|
| Constraints first |  |  |  |
| Source traceability |  |  |  |
| Verification clarity |  |  |  |
| Pressure consistency |  |  |  |
| Overall score |  |  |  |

Conclusion:

- Effectiveness status: fail / partial / pass
- Confidence level: low / medium / high

## 8) REFACTOR Inputs (Evidence-Mapped)

For each observed failure, map directly to one skill change:

| Evidence (quote/path) | Failure Mode | Skill Section to Update | Proposed Patch |
|---|---|---|---|
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

Rules:

- No speculative patch without evidence.
- No broad rewrite if one explicit counter is sufficient.

## 9) Next Iteration Plan

- Changes to apply:
  1.
  2.
  3.
- Re-test scenarios:
  - [ ] Scenario A
  - [ ] Scenario B
  - [ ] Scenario C
- Exit criteria:
  - [ ] No new high-severity rationalizations
  - [ ] GREEN meets threshold in all scenarios
  - [ ] At least one rerun confirms stability
