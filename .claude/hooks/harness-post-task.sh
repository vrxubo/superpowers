#!/usr/bin/env bash
# Harness Post-Task Hook (Claude Code)
# Triggered after task completion to collect execution evidence.

set -euo pipefail

HOOK_EVENT="${1:-unknown}"
TARGET_FILE="${2:-}"

# Only run if docs/memory/ exists
if [ ! -d "docs/memory" ]; then
    exit 0
fi

TODAY=$(date +%Y-%m-%d)
LOG_FILE="docs/memory/execution-log/${TODAY}.md"

mkdir -p "docs/memory/execution-log"

cat >> "${LOG_FILE}" << LOGENTRY

## Hook: Task Completed
- **Time**: $(date +%H:%M)
- **Event**: ${HOOK_EVENT}
- **File**: ${TARGET_FILE}
- **Note**: Run harness-feedback-loop skill to classify outcome and update patterns.
LOGENTRY

exit 0
