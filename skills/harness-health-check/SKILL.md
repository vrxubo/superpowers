---
name: harness-health-check
description: Use when diagnosing Harness environment compliance — evaluates project complexity, checks AGENTS.md rules consistency with actual code, and provides actionable fix recommendations with next steps
---

# Harness Health Check

## Overview

诊断项目的 Harness 环境是否符合实际需求。基于项目复杂度动态调整检查标准，解析 AGENTS.md 提取规则定义并检查代码遵守情况，提供结构化的修复闭环。

**Core principle:**
- AGENTS.md 应控制在 100-150 行。超过 200 行，Agent 的注意力就会被稀释
- 检查的是"这个项目当前的状态，离它应该达到的状态还差什么"，不是"离预设模板还差什么"

## When to Use

- 用户显式调用 `/harness-health-check` 检查当前项目
- 对项目 Harness 环境合规性存疑时
- `harness-knowledge-discovery` 或 `project-standards-authoring` 执行后验证结果

Do not use for:
- 单个文件的简单检查
- 不涉及 Harness 环境的诊断

## Workflow

### Phase 1: 项目复杂度评估

评估维度：

| 维度 | 低复杂度 | 中复杂度 | 高复杂度 |
|------|----------|----------|----------|
| 代码规模（src/ 文件数） | < 50 | 50-200 | > 200 |
| 团队规模（git 作者数） | < 3 | 3-8 | > 8 |
| 模块数量（业务模块目录数） | < 3 | 3-10 | > 10 |

综合评分：取最高维度决定整体复杂度等级。

**检查命令：**

```bash
# 代码规模
find src -type f | wc -l

# 团队规模
git log --format='%aN' | sort -u | wc -l

# 模块数量（React 项目示例）
find src/views -mindepth 1 -maxdepth 1 -type d | wc -l
```

### Phase 2: 动态检查标准

基于复杂度的差异化检查标准：

| 检查项 | 低复杂度 | 中复杂度 | 高复杂度 |
|--------|----------|----------|----------|
| AGENTS.md 存在 | 推荐 | 必须 | 必须 |
| AGENTS.md ≤200 行 | 推荐 | 必须 | 必须 |
| AGENTS.md ≤150 行 | 推荐 | 推荐 | 必须 |
| docs/harness/ 存在 | 可选 | 推荐 | 必须 |
| docs/memory/ 存在 | 不需要 | 可选 | 推荐 |
| docs/checklists/ 存在 | 不需要 | 推荐 | 必须 |
| failure-patterns.md | 不需要 | 可选 | 推荐 |
| 规则一致性检查 | 不需要 | 推荐 | 必须 |

### Phase 3: Harness 结构检查

**Level 1: AGENTS.md 检查**

| 检查项 | 严重程度 | 检查方式 |
|--------|----------|----------|
| 文件存在 | ERROR | 检查 AGENTS.md 或 CLAUDE.md |
| 行数 ≤ 200 | ERROR | `wc -l AGENTS.md` |
| 行数 ≤ 150 | WARNING | `wc -l AGENTS.md` |
| 符号链接正确 | ERROR | 检查 AGENTS.md 是否是 CLAUDE.md 的 symlink |
| Core Index 表格存在 | ERROR | grep "When you need" |
| standards-index 区域为空 | WARNING | 检查 BEGIN/END 标记间内容 |

**Level 2: 目录结构检查**

基于复杂度动态判断严重程度：

| 检查项 | 高复杂度 | 中复杂度 | 低复杂度 |
|--------|----------|----------|----------|
| docs/harness/ 存在 | ERROR | WARNING | INFO |
| docs/memory/ 存在 | WARNING | INFO | N/A |
| docs/memory/execution-log/ 存在 | WARNING | INFO | N/A |
| docs/checklists/ 存在 | ERROR | WARNING | N/A |
| docs/rules/ 存在 | INFO | INFO | INFO |

**Level 3: 文档内容检查**

| 检查项 | 严重程度 |
|--------|----------|
| docs/memory/failure-patterns.md 存在且有模板 | WARNING |
| docs/memory/success-patterns.md 存在且有模板 | WARNING |
| docs/checklists/pre-task.md 存在 | WARNING |
| docs/checklists/code-review.md 存在 | WARNING |
| docs/checklists/post-task.md 存在 | WARNING |
| docs/harness/project-architecture.md 存在 | WARNING |

### Phase 4: 规则一致性检查

**实现路径说明：**

将 AGENTS.md 里的规则文本转换为可执行的检查命令是一个 NLP 问题。有两种实现路径：

| 路径 | 做法 | 优缺点 |
|------|------|--------|
| A. 预定义规则映射表 | 在 Skill 里硬编码常见规则 → 检查模式的映射 | 简单可靠，但只能覆盖常见规则 |
| B. 让 LLM 动态解析 | Skill 读取 AGENTS.md 后，让 LLM 生成检查命令 | 灵活，但可能产生错误命令 |

**当前版本采用路径 A**：预定义映射表覆盖核心规则，等 Skill 跑通后再用路径 B 增强。

**预定义规则检查模板（第一版覆盖范围）：**

| 检查项 | 数据来源 | 检查方式 |
|--------|----------|----------|
| 违规使用 any 类型 | grep `: any` src/ | 计数违规文件数 |
| 组件结构不符合规范 | 扫描组件目录 | 检查 index.tsx + index.module.scss |
| 服务层使用非 POST 方法 | 扫描 src/services/ | 检查 HTTP 方法 |
| 类型定义位置违规 | 扫描 interface/type 定义位置 | 检查是否在 @/types/ |
| 目录结构约束 | 扫描 import 路径 | 检查跨层 import |

### Phase 5: 输出报告 + 修复闭环

输出结构化报告，包含当前状态、目标状态、差距、修复建议、下一步行动。

## Output Format

```markdown
## Harness Health Check Report

**Project:** [项目名称]
**复杂度评估:** 高（>200 文件，>8 贡献者，>10 业务模块）
**Checked:** YYYY-MM-DD HH:MM

### Summary

| Level | Count |
|-------|-------|
| ERROR | N |
| WARNING | M |
| INFO | K |

### Errors（高复杂度项目必须项）

- ❌ **AGENTS.md 行数超限**: 287 行（限制: 150）
  - **当前状态**: 287 行
  - **目标状态**: ≤150 行
  - **差距**: 137 行需要精简
  - **修复建议**: 将规则详情移至 docs/rules/，AGENTS.md 只保留索引表格

- ❌ **违规使用 any 类型**: 23 个文件
  - **规则来源**: AGENTS.md "## TypeScript 规范 - 禁止使用 any"
  - **违规文件**: src/views/UserProfile/index.tsx (5处) 等
  - **修复建议**: 将 any 替换为具体类型或 unknown

### Warnings（高复杂度项目推荐项）

- ⚠️ **failure-patterns.md 缺失**
  - **当前状态**: 不存在
  - **目标状态**: 存在并有模板
  - **差距**: 需创建文件
  - **修复建议**: 创建 docs/memory/failure-patterns.md 并添加模板

### Passed（已满足项）

- ✅ docs/checklists/ 存在（高复杂度必须项，已满足）
- ✅ docs/harness/project-architecture.md 存在（已满足）

### 不适用（低复杂度项目才需要）

- N/A docs/memory/execution-log/ - 高复杂度项目当前阶段暂不需要

---

## Next Actions

### 1. 立即修复（ERROR 级别）

| 行动 | 执行方式 |
|------|----------|
| 精简 AGENTS.md | 手动编辑，将规则详情移至 docs/rules/index.md |
| 修复 any 类型违规 | 运行 grep -r ": any" src/ 定位，逐文件替换 |

### 2. 计划修复（WARNING 级别）

| 行动 | 执行方式 |
|------|----------|
| 创建 failure-patterns.md | 运行 /harness-knowledge-discovery 或手动创建 |

### 3. 验证修复

```bash
# 修复后重新运行 Health Check
/harness-health-check
```

### 4. 持续监控

建议将 Health Check 加入 CI/CD 流程，每次 PR 自动检查 Harness 环境合规性。
```

## Quick Reference

| 检查阶段 | 核心检查项 |
|----------|-----------|
| Phase 1 | 代码规模、团队规模、模块数量 |
| Phase 2 | 基于复杂度选择检查标准 |
| Phase 3 | AGENTS.md 行数、目录结构、文档内容 |
| Phase 4 | 预定义规则一致性检查（any 类型、组件结构等） |
| Phase 5 | 输出报告 + Next Actions 表格 |

## Red Flags

- 你跳过了项目复杂度评估，直接使用固定检查标准
- 你检查了低复杂度项目不需要的文档（如 failure-patterns.md）
- 你输出的报告没有"当前状态 + 目标状态 + 差距"结构
- 你没有提供可执行的 Next Actions 表格
- 你只检查了"文件在不在"，没有检查"规则是否被遵守"

**All red flags mean:** 重新审视检查流程，确保基于项目实际需求而非模板思维。

## Common Mistakes

- 对所有项目使用相同的检查标准（忽略复杂度差异）
- 输出报告只有问题列表，没有修复建议和下一步行动
- 检查规则一致性时只做 grep，不统计违规数量和文件位置
- 跳过 AGENTS.md 行数检查（这是最常见的坑）

## Future Iterations

- 支持 AGENTS.md 规则自定义检查模板
- 检查 Hook 配置（.cursor/hooks.json）
- 支持 CLI 输出格式（JSON/YAML）便于 CI 集成
- 支持增量检查（只检查变更文件）
- 生成修复 PR 的自动化 workflow