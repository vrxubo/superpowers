# Project Governance Standards

## Rule Objective

Ensure project contributions follow consistent processes: PR workflows, contributor guidelines, and documentation standards.

## When to Use

- Submitting a PR to this repository
- Setting up new project governance files
- Modifying contributor guidelines

## Out of Scope

- Code standards for application code (this project has no application code)
- Domain-specific plugin conventions
- External tool configuration

---

## Sources

| Source | Path |
|--------|------|
| CLAUDE.md | `CLAUDE.md` (90 lines) |
| AGENTS.md | `AGENTS.md` → symlink to CLAUDE.md |
| PR template | `.github/PULL_REQUEST_TEMPLATE.md` |
| README | `README.md` |
| Git hooks | `hooks/` |
| GitHub workflows | `.github/workflows/` |

---

## Must (enforced by quality gates)

### GOV-1: PR template completion
**Rule:** Every PR MUST fully complete the PR template. No section left blank or filled with placeholder text.
**Source:** `CLAUDE.md` line 23: "Every PR must fully complete the PR template."

### GOV-2: Prior PR search
**Rule:** Before opening a PR, MUST search both open AND closed PRs for related work. Reference what was found.
**Source:** `CLAUDE.md` line 25

### GOV-3: Human review required
**Rule:** A human MUST review the complete proposed diff before submission. PRs showing no evidence of human involvement will be closed.
**Source:** `CLAUDE.md` line 27

### GOV-4: Zero dependencies
**Rule:** PRs MUST NOT add optional or required dependencies on third-party projects (except new harness support).
**Source:** `CLAUDE.md` line 33

### GOV-5: Skill changes require writing-skills
**Rule:** Any skill creation, modification, or deletion MUST use `superpowers:writing-skills`. Direct edits to `skills/**/SKILL.md` are forbidden.
**Source:** `CLAUDE.md` line 69: "IRON LAW"

### GOV-6: One problem per PR
**Rule:** Each PR MUST address exactly one problem. Bundled unrelated changes will be closed.
**Source:** `CLAUDE.md` line 83

### GOV-7: Describe problem solved
**Rule:** PR description MUST describe the problem solved, not just what changed. Every PR must solve a real problem someone actually experienced.
**Source:** `CLAUDE.md` line 85

---

## Should (recommended)

### GOV-8: Test on at least one harness
**Rule:** Test the change on at least one harness (Cursor, Claude Code, etc.) and report results.
**Source:** `CLAUDE.md` line 84

### GOV-9: Language consistency
**Rule:** Output language should match the human partner's requested language. If repository policy conflicts, surface explicitly.
**Source:** `CLAUDE.md` line 78 + Rationalization Table

### GOV-10: Git hygiene
**Rule:** Commits should have clear messages. Branches should be cleaned up after merge.
**Source:** Standard git practices referenced throughout

---

## Must Avoid (anti-patterns)

### GOV-11: Fabricated content
**Rule:** PRs MUST NOT contain invented claims, fabricated problem descriptions, or hallucinated functionality.
**Source:** `CLAUDE.md` lines 60-61

### GOV-12: Batch/spray-and-pray PRs
**Rule:** Do NOT open PRs for multiple issues in a single session. Pick ONE issue, understand it deeply.
**Source:** `CLAUDE.md` lines 44-46

### GOV-13: Speculative fixes
**Rule:** Do NOT submit PRs for theoretical issues. "Could theoretically cause issues" is not a problem statement.
**Source:** `CLAUDE.md` lines 48-50

### GOV-14: Compliance changes without evals
**Rule:** Do NOT restructure skills to "comply" with external documentation without extensive eval evidence.
**Source:** `CLAUDE.md` lines 36-38

### GOV-15: Fork-specific changes
**Rule:** Do NOT open PRs to sync forks or push fork-specific features upstream.
**Source:** `CLAUDE.md` lines 56-58
