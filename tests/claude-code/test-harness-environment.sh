#!/usr/bin/env bash
# Harness Environment Phase 1 Validation Test
set -euo pipefail

PASS=0
FAIL=0
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

check() {
    local desc="$1"
    local condition="$2"
    if eval "$condition"; then
        echo "PASS: ${desc}"
        ((PASS++))
    else
        echo "FAIL: ${desc}"
        ((FAIL++))
    fi
}

echo "=== Harness Environment Phase 1 Validation ==="
echo ""

# Check agent.md
check "agent.md exists" "[ -f '${ROOT}/agent.md' ]"
check "agent.md under 200 lines" "[ \$(wc -l < '${ROOT}/agent.md') -lt 200 ]"
check "agent.md has core index table" "grep -q 'Core Index' '${ROOT}/agent.md'"
check "agent.md has scenario trigger rules" "grep -q 'Scenario Trigger Rules' '${ROOT}/agent.md'"

# Check docs/harness/
check "docs/harness/ exists" "[ -d '${ROOT}/docs/harness' ]"
check "project-architecture.md exists" "[ -f '${ROOT}/docs/harness/project-architecture.md' ]"

# Check docs/memory/
check "docs/memory/ exists" "[ -d '${ROOT}/docs/memory' ]"
check "failure-patterns.md exists" "[ -f '${ROOT}/docs/memory/failure-patterns.md' ]"
check "success-patterns.md exists" "[ -f '${ROOT}/docs/memory/success-patterns.md' ]"
check "execution-log/ exists" "[ -d '${ROOT}/docs/memory/execution-log' ]"

# Check docs/checklists/
check "docs/checklists/ exists" "[ -d '${ROOT}/docs/checklists' ]"
check "pre-task.md exists" "[ -f '${ROOT}/docs/checklists/pre-task.md' ]"
check "code-review.md exists" "[ -f '${ROOT}/docs/checklists/code-review.md' ]"
check "post-task.md exists" "[ -f '${ROOT}/docs/checklists/post-task.md' ]"

# Check skills
check "harness-knowledge-discovery skill exists" "[ -f '${ROOT}/skills/harness-knowledge-discovery/SKILL.md' ]"
check "harness-feedback-loop skill exists" "[ -f '${ROOT}/skills/harness-feedback-loop/SKILL.md' ]"

# Check skill frontmatter
check "harness-knowledge-discovery has YAML frontmatter" "grep -q '^---' '${ROOT}/skills/harness-knowledge-discovery/SKILL.md'"
check "harness-feedback-loop has YAML frontmatter" "grep -q '^---' '${ROOT}/skills/harness-feedback-loop/SKILL.md'"

# Check hooks
check "Cursor harness hook exists" "[ -f '${ROOT}/.cursor/hooks/harness-post-task.sh' ]"
check "Claude Code harness hook exists" "[ -f '${ROOT}/.claude/hooks/harness-post-task.sh' ]"
check "Cursor hook is executable" "[ -x '${ROOT}/.cursor/hooks/harness-post-task.sh' ]"
check "Claude Code hook is executable" "[ -x '${ROOT}/.claude/hooks/harness-post-task.sh' ]"

echo ""
echo "=== Results: ${PASS} passed, ${FAIL} failed ==="

if [ "${FAIL}" -gt 0 ]; then
    exit 1
fi
