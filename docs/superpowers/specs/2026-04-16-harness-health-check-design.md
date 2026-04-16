# Harness Health Check Skill Design

## Overview

诊断项目的 Harness 环境是否符合设计规范，检测 AGENTS.md 行数超限、目录缺失、文档格式问题等，并提供修复建议。

**Core principle:** AGENTS.md 应控制在 100-150 行。超过 200 行，Agent 的注意力就会被稀释，它会开始"选择性地忽略"规则。

## When to Use

- 用户显式调用 `/harness-health-check` 检查当前项目
- 对项目 Harness 环境合规性存疑时
- `harness-knowledge-discovery` 或 `project-standards-authoring` 执行后验证结果

## Check Items

### Level 1: AGENTS.md 检查（最关键）

| 检查项 | 严重程度 | 说明 |
|--------|----------|------|
| 行数 ≤ 200 | ERROR | 超过 200 行会稀释 Agent 注意力 |
| 行数 ≤ 150（推荐） | WARNING | 最佳范围是 100-150 行 |
| 文件存在 | ERROR | 必须存在 AGENTS.md 或 CLAUDE.md |
| 符号链接正确 | ERROR | AGENTS.md 应是 CLAUDE.md 的符号链接（或反过来） |
| Core Index 表格存在 | ERROR | 必须包含 "When you need..." 索引表格 |
| standards-index 区域为空 | WARNING | 应为空占位符，等待 project-standards-authoring 填充 |

### Level 2: 目录结构检查

| 检查项 | 严重程度 | 说明 |
|--------|----------|------|
| `docs/harness/` 存在 | ERROR | 项目架构文档目录 |
| `docs/memory/` 存在 | ERROR | 执行记忆目录 |
| `docs/memory/execution-log/` 存在 | ERROR | 执行日志子目录 |
| `docs/checklists/` 存在 | ERROR | 任务检查清单目录 |
| `docs/rules/` 存在 | WARNING | 编码规范目录 |

### Level 3: 文档内容检查

| 检查项 | 严重程度 | 说明 |
|--------|----------|------|
| `docs/memory/failure-patterns.md` 存在且有模板 | WARNING | 失败模式记录文件 |
| `docs/memory/success-patterns.md` 存在且有模板 | WARNING | 成功模式记录文件 |
| `docs/checklists/pre-task.md` 存在 | WARNING | 任务前检查清单 |
| `docs/checklists/code-review.md` 存在 | WARNING | 代码审查检查清单 |
| `docs/checklists/post-task.md` 存在 | WARNING | 任务后检查清单 |
| `docs/harness/project-architecture.md` 存在 | WARNING | 项目架构文档 |

## Output Format

```markdown
## Harness Health Check Report

**Project:** [project name]
**Checked:** YYYY-MM-DD HH:MM

### Summary

| Level | Count |
|-------|-------|
| ERROR | N |
| WARNING | M |
| INFO | K |

### Errors

- ❌ **AGENTS.md 行数超限**: 287 行（限制: 200）
  - **修复建议**: 将规则详情移至 `docs/rules/index.md`，AGENTS.md 只保留索引表格

- ❌ **docs/harness/ 目录缺失**
  - **修复建议**: 运行 `harness-knowledge-discovery` skill 生成完整 Harness 环境

### Warnings

- ⚠️ **AGENTS.md 行数超推荐值**: 178 行（推荐: ≤150）
  - **修复建议**: 精简 Core Index 表格，移除冗余描述

### Passed Checks

- ✅ docs/memory/ 目录存在
- ✅ docs/checklists/ 目录存在
- ✅ AGENTS.md → CLAUDE.md 符号链接正确
```

## Skill Metadata

```yaml
name: harness-health-check
description: Use when diagnosing Harness environment compliance — AGENTS.md line count, directory structure, and document format validation with fix recommendations
```

## File Structure

```
skills/harness-health-check/
└── SKILL.md              # Main skill document
```

## Future Iterations

- 检查 `docs/rules/index.md` 内容格式
- 检查 `docs/harness/knowledge-blueprint.md` 是否存在
- 检查 Hook 配置（`.cursor/hooks.json` 或 `hooks.json`）
- 支持不同项目类型的差异化检查标准