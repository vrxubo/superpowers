# Testing & Quality Checklist

> Every test script or quality gate MUST pass all items below.

## Structure
- [ ] `#!/usr/bin/env bash` shebang
- [ ] `set -euo pipefail` error handling
- [ ] ROOT resolved dynamically: `ROOT="$(cd "$(dirname "$0")/../.." && pwd)"`
- [ ] File has executable permission

## Output
- [ ] Each check outputs `PASS:` or `FAIL:` with descriptive message
- [ ] Summary at end: `=== Results: N passed, M failed ===`
- [ ] Exit code 0 if all pass, 1 if any fail

## Safety
- [ ] Counter increments guarded: `((PASS++)) || true`
- [ ] No hardcoded absolute paths
- [ ] No network calls or external service dependencies
- [ ] Test runs offline, fully self-contained

## Organization
- [ ] Test script named `test-<feature>.sh`
- [ ] Related test output stored in `docs/testing-reports/<skill>-<harness>/`
- [ ] README documents how to run tests

## Validation
- [ ] All checks pass locally
- [ ] Bash syntax validated with `bash -n`
- [ ] Test covers all required assertions for the feature
