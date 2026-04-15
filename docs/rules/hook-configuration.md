# Hook Configuration Standards

## Rule Objective

Ensure hooks are reliable, secure, and follow consistent patterns for both Cursor and Claude Code platforms.

## When to Use

- Creating new hooks for Cursor or Claude Code
- Modifying existing hook scripts or configuration
- Setting up session-start hooks or post-task hooks

## Out of Scope

- Skills (live in `skills/`)
- CI/CD workflows (live in `.github/workflows/`)
- Local development scripts (live in `scripts/`)

---

## Sources

| Source | Path |
|--------|------|
| Hooks directory | `hooks/` |
| Hooks config | `hooks.json`, `hooks-cursor.json` |
| Session-start hook | `hooks/session-start/` |
| Harness hooks | `.cursor/hooks/harness-post-task.sh`, `.claude/hooks/harness-post-task.sh` |
| .gitignore rules | `.gitignore` lines 8-15 |

---

## Must (enforced by quality gates)

### HOOK-1: Platform compatibility
**Rule:** Hooks MUST work on both macOS and Linux. Use `#!/usr/bin/env bash` shebang. Avoid platform-specific commands.
**Source:** `hooks/run-hook.cmd` shows Windows support consideration; harness hooks use `set -euo pipefail`

### HOOK-2: Fail-safe by default
**Rule:** Hooks MUST exit 0 gracefully if preconditions are not met (e.g., `docs/memory/` doesn't exist). Never break the agent flow.
**Source:** `.cursor/hooks/harness-post-task.sh` — `if [ ! -d "docs/memory" ]; then exit 0; fi`

### HOOK-3: .gitignore awareness
**Rule:** Understand which hooks are committed and which are ignored. `.cursor/hooks/` and `.claude/` are gitignored by default; exceptions must be explicitly added.
**Source:** `.gitignore` lines 8-15

### HOOK-4: Executable permission
**Rule:** All hook scripts MUST have executable permission (`chmod +x`).
**Source:** Test validation checks `hook is executable`

### HOOK-5: No secrets or credentials
**Rule:** Hooks MUST NOT contain API keys, tokens, or credentials. Use environment variables if needed.
**Source:** General security principle from `CLAUDE.md` contributor guidelines

---

## Should (recommended)

### HOOK-6: Idempotent execution
**Rule:** Running a hook multiple times should produce the same result as running it once. Use append (`>>`) for logs, not overwrite.
**Source:** `.cursor/hooks/harness-post-task.sh` uses `cat >> "${LOG_FILE}"`

### HOOK-7: Clear naming convention
**Rule:** Hook names should be descriptive: `<event>-<purpose>.sh` (e.g., `harness-post-task.sh`).
**Source:** Actual naming: `harness-post-task.sh`

### HOOK-8: Bash syntax validation
**Rule:** Validate hook syntax with `bash -n <file>` before committing.
**Source:** Test script runs `bash -n` validation

---

## Must Avoid (anti-patterns)

### HOOK-9: Silent failures
**Rule:** Do NOT swallow errors with `set -e` without logging. Use `set -euo pipefail` and log failures.
**Source:** Harness hooks use `set -euo pipefail`

### HOOK-10: Blocking hooks
**Rule:** Hooks MUST NOT block or wait for user input. They run automatically.
**Source:** `harness-post-task.sh` design pattern

### HOOK-11: Hardcoded paths
**Rule:** Use relative paths or environment variables. Do NOT hardcode absolute paths like `/Users/xxx/`.
**Source:** Harness hooks use relative `docs/memory/execution-log/`
