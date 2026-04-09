#!/usr/bin/env bash
# Real-world skill validation runner
# Runs one scenario against a real target repo and generates a structured report.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

TARGET_REPO=""
TARGET_SKILL="superpowers:standards-context-retrieval"
SCENARIO="feature"
TIMEOUT_SECONDS=900
BASELINE_MODE=false
RUN_LABEL=""

usage() {
  echo "Usage: $0 --target-repo /abs/path [options]"
  echo ""
  echo "Options:"
  echo "  --target-repo PATH     Absolute path to real project repository (required)"
  echo "  --skill NAME           Skill to validate (default: superpowers:standards-context-retrieval)"
  echo "  --scenario NAME        Scenario type: feature|bugfix|refactor|custom (default: feature)"
  echo "  --timeout SECONDS      Claude timeout in seconds (default: 900)"
  echo "  --baseline             Run RED baseline without enforcing target skill"
  echo "  --run-label LABEL      Optional run label"
  echo "  --help                 Show this help"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target-repo)
      TARGET_REPO="$2"
      shift 2
      ;;
    --skill)
      TARGET_SKILL="$2"
      shift 2
      ;;
    --scenario)
      SCENARIO="$2"
      shift 2
      ;;
    --timeout)
      TIMEOUT_SECONDS="$2"
      shift 2
      ;;
    --baseline)
      BASELINE_MODE=true
      shift
      ;;
    --run-label)
      RUN_LABEL="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$TARGET_REPO" ]]; then
  echo "ERROR: --target-repo is required"
  usage
  exit 1
fi

if [[ ! -d "$TARGET_REPO" ]]; then
  echo "ERROR: target repo does not exist: $TARGET_REPO"
  exit 1
fi

if [[ -z "$RUN_LABEL" ]]; then
  RUN_LABEL="$(date +%Y%m%d-%H%M%S)-${SCENARIO}"
fi

OUTPUT_DIR="$ROOT_DIR/docs/testing-reports/$RUN_LABEL"
mkdir -p "$OUTPUT_DIR"

PROMPT_FILE="$OUTPUT_DIR/prompt.txt"
OUTPUT_FILE="$OUTPUT_DIR/claude-output.txt"
REPORT_FILE="$OUTPUT_DIR/report.md"
META_FILE="$OUTPUT_DIR/meta.txt"

if [[ "$BASELINE_MODE" == true ]]; then
  cat > "$PROMPT_FILE" <<EOF
你在真实项目路径 $TARGET_REPO 中执行一个${SCENARIO}场景任务。

任务要求：
1) 给出可执行方案并说明将如何修改代码
2) 输出你会收集的验证证据
3) 最后给出一个简短复盘

注意：不要显式调用任何技能文档。
EOF
else
  cat > "$PROMPT_FILE" <<EOF
你在真实项目路径 $TARGET_REPO 中执行一个${SCENARIO}场景任务。

强制要求：
1) 必须先使用技能：$TARGET_SKILL
2) 必须先输出 "Constraints Summary" 且包含 "Sources Consulted"
3) 再输出执行步骤与合规检查

最后提供可执行的优化建议。
EOF
fi

echo "run_label=$RUN_LABEL" > "$META_FILE"
echo "target_repo=$TARGET_REPO" >> "$META_FILE"
echo "target_skill=$TARGET_SKILL" >> "$META_FILE"
echo "scenario=$SCENARIO" >> "$META_FILE"
echo "baseline_mode=$BASELINE_MODE" >> "$META_FILE"
echo "timeout_seconds=$TIMEOUT_SECONDS" >> "$META_FILE"

echo "========================================"
echo " Real-World Skill Validation"
echo "========================================"
echo "Run label: $RUN_LABEL"
echo "Target repo: $TARGET_REPO"
echo "Skill: $TARGET_SKILL"
echo "Scenario: $SCENARIO"
echo "Baseline mode: $BASELINE_MODE"
echo ""

PROMPT_TEXT="$(python3 -c 'import pathlib,sys; print(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))' "$PROMPT_FILE")"

cd "$ROOT_DIR"
timeout "$TIMEOUT_SECONDS" claude -p "$PROMPT_TEXT" \
  --allowed-tools=all \
  --add-dir "$TARGET_REPO" \
  --permission-mode bypassPermissions \
  2>&1 | tee "$OUTPUT_FILE"

WORKING_DIR_ESCAPED=$(echo "$ROOT_DIR" | sed 's/\//-/g' | sed 's/^-//')
SESSION_DIR="$HOME/.claude/projects/$WORKING_DIR_ESCAPED"
SESSION_FILE=$(ls -t "$SESSION_DIR"/*.jsonl 2>/dev/null | head -1)

if [[ -z "${SESSION_FILE:-}" ]]; then
  echo "ERROR: Could not locate session transcript in $SESSION_DIR"
  exit 1
fi

echo "session_file=$SESSION_FILE" >> "$META_FILE"

python3 "$SCRIPT_DIR/analyze-real-world-skill-validation.py" \
  --session-file "$SESSION_FILE" \
  --skill "$TARGET_SKILL" \
  --scenario "$SCENARIO" \
  --target-repo "$TARGET_REPO" \
  --run-label "$RUN_LABEL" \
  --report-file "$REPORT_FILE"

echo ""
echo "Artifacts:"
echo "  Prompt: $PROMPT_FILE"
echo "  Output: $OUTPUT_FILE"
echo "  Report: $REPORT_FILE"
echo "  Meta:   $META_FILE"
