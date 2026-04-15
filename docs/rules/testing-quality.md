# Testing & Quality Standards

## Rule Objective

Ensure tests are reliable, follow TDD principles, and provide meaningful quality gates for the project.

## When to Use

- Writing new tests or test scripts
- Modifying test infrastructure
- Setting up quality gates for skill validation

## Out of Scope

- Runtime unit tests for application code (this project has no application code)
- Performance benchmarks
- Integration tests for external services

---

## Sources

| Source | Path |
|--------|------|
| Testing documentation | `docs/testing.md` (445 lines) |
| Test scripts | `tests/claude-code/test-*.sh` |
| Test-driven-development skill | `skills/test-driven-development/SKILL.md` |
| Verification-before-completion skill | `skills/verification-before-completion/SKILL.md` |
| Systematic-debugging skill | `skills/systematic-debugging/SKILL.md` |
| Validation reports | `docs/testing-reports/` |

---

## Must (enforced by quality gates)

### TEST-1: TDD for tests
**Rule:** Write the failing test first, run it to verify it fails, then write minimal implementation code.
**Source:** `skills/test-driven-development/SKILL.md`

### TEST-2: Tests must be executable
**Rule:** Every test script MUST have executable permission and run with `bash <script>` or `bash tests/claude-code/test-*.sh`.
**Source:** `tests/claude-code/test-harness-environment.sh` (22 checks, all pass)

### TEST-3: Clear PASS/FAIL reporting
**Rule:** Tests MUST output `PASS:` or `FAIL:` for each check, with a summary count at the end.
**Source:** `tests/claude-code/test-harness-environment.sh` — `echo "=== Results: ${PASS} passed, ${FAIL} failed ==="`

### TEST-4: Exit code reflects result
**Rule:** Tests MUST exit with code 0 if all pass, code 1 if any fail.
**Source:** `tests/claude-code/test-harness-environment.sh` — `if [ "${FAIL}" -gt 0 ]; then exit 1; fi`

### TEST-5: set -e safety
**Rule:** Test scripts MUST use `set -euo pipefail` but guard counter increments (`((PASS++)) || true`) to avoid aborting on zero-to-one increment.
**Source:** Bug fixed in test-harness-environment.sh where `((FAIL++))` at FAIL=0 returned exit code 1

### TEST-6: Root-relative paths
**Rule:** Tests MUST resolve ROOT path dynamically: `ROOT="$(cd "$(dirname "$0")/../.." && pwd)"`
**Source:** `tests/claude-code/test-harness-environment.sh` line 6

---

## Should (recommended)

### TEST-7: Test organization by skill
**Rule:** Organize test scripts by skill or feature area (e.g., `test-project-standards-authoring.sh`, `test-harness-environment.sh`).
**Source:** `tests/claude-code/` directory structure

### TEST-8: Validation reports
**Rule:** Store test output in `docs/testing-reports/<skill-name>-<harness>/` for traceability.
**Source:** `docs/testing-reports/project-standards-authoring-red/`, `docs/testing-reports/project-standards-authoring-cursor-green/`

### TEST-9: README for test suite
**Rule:** `tests/` directory MUST have a README explaining how to run tests and what each script validates.
**Source:** `tests/claude-code/README.md` (145 lines)

---

## Must Avoid (anti-patterns)

### TEST-10: Silent test failures
**Rule:** Do NOT let tests fail without outputting which check failed. Every failure must report the specific condition that failed.
**Source:** `check()` function pattern with descriptive message

### TEST-11: Hardcoded test paths
**Rule:** Do NOT hardcode absolute paths in test scripts. Always resolve ROOT dynamically.
**Source:** `ROOT="$(cd "$(dirname "$0")/../.." && pwd)"`

### TEST-12: Tests that depend on external services
**Rule:** Tests MUST be fully self-contained and runnable offline. No network calls.
**Source:** `docs/testing.md` — all tests use local bash commands
