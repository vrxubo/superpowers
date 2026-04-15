# Hook Configuration Checklist

> Every hook creation or modification MUST pass all items below.

## Structure
- [ ] `#!/usr/bin/env bash` shebang
- [ ] `set -euo pipefail` error handling
- [ ] File extension is `.sh` (not `.cmd` unless Windows-specific)
- [ ] File has executable permission (`chmod +x`)

## Safety
- [ ] Exits 0 gracefully if preconditions not met
- [ ] No secrets, credentials, or API keys
- [ ] No hardcoded absolute paths
- [ ] No blocking or interactive input
- [ ] Idempotent (safe to run multiple times)

## Quality
- [ ] Bash syntax validated with `bash -n <file>`
- [ ] .gitignore status understood (will this be committed?)
- [ ] Works on both macOS and Linux
- [ ] Clear, descriptive name (`<event>-<purpose>.sh`)

## Testing
- [ ] Hook runs successfully in isolation
- [ ] Hook handles missing directories/files gracefully
- [ ] Hook produces expected output
