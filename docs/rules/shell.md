# Shell Script Standards

Applies to all `.sh` files: test runners, hooks, scaffolding scripts, and utility scripts.

## General

- Always start with `#!/usr/bin/env bash` (not `#!/bin/bash`) for portability.
- Use `set -euo pipefail` in scripts that perform sequential operations where any failure should abort.
- Quote all variable expansions: `"$var"`, not `$var`.
- Prefer `[[ ]]` over `[ ]` for conditionals.

## Naming

- Lowercase with underscores: `run-skill-tests.sh`, `test_helpers.sh`.
- Test scripts: prefix with `test-` or suffix with `.test.sh`.
- Hook scripts: name by lifecycle event: `beforeShell.sh`, `afterMcp.sh`.

## Functions

- Declare functions with `function name() { ... }` or `name() { ... }` — pick one style per file, do not mix.
- Local variables must use `local`: `local result="$1"`.
- Return explicit exit codes: `return 0` for success, `return 1` for failure.

## Output

- Use `echo` for user-facing messages, `>&2` for errors.
- Do not leave debug `set -x` in committed scripts.

## Dependencies

- Do not assume tools beyond coreutils, bash builtins, and git without a presence check.
- Use `command -v <tool>` to check tool availability before use.

## Test Scripts

- Test scripts must exit non-zero on any failure.
- Use `trap` for cleanup on EXIT when creating temporary resources.
- Group related assertions; print a summary line at the end.
