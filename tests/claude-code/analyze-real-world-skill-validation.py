#!/usr/bin/env python3
"""
Analyze a Claude session transcript for real-world skill validation runs.
Generates a markdown report with structured evidence fields.
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


RATIONALIZATION_PATTERNS = [
    r"time\s+is\s+short",
    r"mental\s+checklist",
    r"generic\s+best\s+practices",
    r"fix\s+standards\s+later",
    r"pragmatic",
    r"skip\s+.*verification",
]


@dataclass
class AnalysisResult:
    skill_invoked: bool
    constraints_summary_present: bool
    sources_consulted_present: bool
    compliance_section_present: bool
    constraints_before_steps: bool
    rationalization_hits: list[str]
    assistant_text_chars: int
    score: int
    max_score: int


def _iter_jsonl(path: Path) -> Iterable[dict]:
    with path.open("r", encoding="utf-8") as f:
        for raw in f:
            raw = raw.strip()
            if not raw:
                continue
            try:
                yield json.loads(raw)
            except json.JSONDecodeError:
                continue


def _extract_assistant_text(events: Iterable[dict]) -> str:
    chunks: list[str] = []
    for event in events:
        if event.get("type") != "assistant":
            continue
        msg = event.get("message", {})
        for item in msg.get("content", []):
            if isinstance(item, dict) and item.get("type") == "text":
                text = item.get("text", "")
                if text:
                    chunks.append(text)
    return "\n\n".join(chunks)


def _skill_invoked(events: Iterable[dict], target_skill: str) -> bool:
    for event in events:
        if event.get("type") != "assistant":
            continue
        msg = event.get("message", {})
        for item in msg.get("content", []):
            if not isinstance(item, dict):
                continue
            if item.get("type") != "tool_use":
                continue
            if item.get("name") != "Skill":
                continue
            tool_input = item.get("input", {})
            if isinstance(tool_input, dict) and tool_input.get("skill") == target_skill:
                return True
    return False


def analyze(session_file: Path, target_skill: str) -> AnalysisResult:
    events = list(_iter_jsonl(session_file))
    text = _extract_assistant_text(events)
    lower_text = text.lower()

    skill_invoked = _skill_invoked(events, target_skill)
    constraints_summary_present = "constraints summary" in lower_text
    sources_consulted_present = "sources consulted" in lower_text
    compliance_section_present = "compliance" in lower_text

    constraints_idx = lower_text.find("constraints summary")
    steps_idx = min(
        [i for i in [lower_text.find("step 1"), lower_text.find("execution steps"), lower_text.find("implement")] if i != -1],
        default=-1,
    )
    constraints_before_steps = constraints_idx != -1 and (steps_idx == -1 or constraints_idx < steps_idx)

    hits: list[str] = []
    for pattern in RATIONALIZATION_PATTERNS:
        if re.search(pattern, lower_text):
            hits.append(pattern)

    score_items = [
        skill_invoked,
        constraints_summary_present,
        sources_consulted_present,
        compliance_section_present,
        constraints_before_steps,
    ]
    score = sum(1 for item in score_items if item)

    return AnalysisResult(
        skill_invoked=skill_invoked,
        constraints_summary_present=constraints_summary_present,
        sources_consulted_present=sources_consulted_present,
        compliance_section_present=compliance_section_present,
        constraints_before_steps=constraints_before_steps,
        rationalization_hits=hits,
        assistant_text_chars=len(text),
        score=score,
        max_score=len(score_items),
    )


def build_report(
    result: AnalysisResult,
    *,
    target_skill: str,
    scenario: str,
    target_repo: str,
    session_file: str,
    run_label: str,
) -> str:
    status = "PASS" if result.score >= 4 else "FAIL"
    rationalizations = ", ".join(result.rationalization_hits) if result.rationalization_hits else "none detected"
    return f"""# Real-World Skill Validation Report

- Run Label: {run_label}
- Skill: `{target_skill}`
- Scenario: `{scenario}`
- Target Repo: `{target_repo}`
- Session File: `{session_file}`

## Compliance Score

- Score: **{result.score}/{result.max_score}**
- Status: **{status}**

## Evidence Checks

- Skill invoked: {result.skill_invoked}
- Constraints Summary present: {result.constraints_summary_present}
- Sources Consulted present: {result.sources_consulted_present}
- Compliance section present: {result.compliance_section_present}
- Constraints appear before implementation steps: {result.constraints_before_steps}

## Risk Signals

- Rationalization pattern hits: {rationalizations}
- Assistant text size (chars): {result.assistant_text_chars}

## Suggested Next Actions

1. If any check is false, patch the target skill with explicit wording for that missing behavior.
2. If rationalization hits are present, add explicit counters to target skill rationalization table and red flags.
3. Re-run the same scenario and compare score delta.
"""


def main() -> int:
    parser = argparse.ArgumentParser(description="Analyze real-world skill validation transcript.")
    parser.add_argument("--session-file", required=True, help="Path to Claude session JSONL file.")
    parser.add_argument("--skill", required=True, help="Target skill identifier.")
    parser.add_argument("--scenario", required=True, help="Scenario label (feature|bugfix|refactor|custom).")
    parser.add_argument("--target-repo", required=True, help="Absolute path to tested repository.")
    parser.add_argument("--run-label", required=True, help="Unique run label for report metadata.")
    parser.add_argument("--report-file", required=True, help="Where to write markdown report.")
    args = parser.parse_args()

    session_file = Path(args.session_file)
    if not session_file.exists():
        raise SystemExit(f"Session file not found: {session_file}")

    result = analyze(session_file, args.skill)
    report = build_report(
        result,
        target_skill=args.skill,
        scenario=args.scenario,
        target_repo=args.target_repo,
        session_file=str(session_file),
        run_label=args.run_label,
    )

    report_file = Path(args.report_file)
    report_file.parent.mkdir(parents=True, exist_ok=True)
    report_file.write_text(report, encoding="utf-8")

    print(f"Report written: {report_file}")
    print(f"Score: {result.score}/{result.max_score}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
