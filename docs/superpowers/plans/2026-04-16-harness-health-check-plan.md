# harness-health-check Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:writing-skills` to implement this plan. This is a skill file creation, which requires the writing-skills workflow for TDD validation.

**Goal:** 创建 `harness-health-check` skill，诊断项目的 Harness 环境合规性，基于项目复杂度动态调整检查标准，解析 AGENTS.md 规则并检查代码遵守情况，提供结构化的修复闭环。

**Architecture:** 四阶段检查流程：项目复杂度评估 → 动态检查标准 → Harness 结构检查 → 规则一致性检查 → 输出报告 + 修复闭环。第一版采用预定义规则映射表，后续迭代支持 LLM 动态解析。

**Tech Stack:** Skill 文件（Markdown），Shell 命令（grep、find、wc）用于检查执行

---

## 文件结构

| 文件 | 操作 | 职责 |
|------|------|------|
| `skills/harness-health-check/SKILL.md` | 创建 | Skill 主文档，包含完整检查流程和输出格式 |

---

### Task 1: 创建 skill 目录结构

**Files:**
- Create: `skills/harness-health-check/SKILL.md`

- [ ] **Step 1: 使用 writing-skills skill 开始创建**

启动 writing-skills workflow，声明创建目标：
- Skill 名称：`harness-health-check`
- Skill 类型：Technique（诊断技术）
- 核心功能：Harness 环境健康检查 + 项目复杂度评估 + 规则一致性检查

- [ ] **Step 2: 创建 SKILL.md 文件骨架**

创建文件并写入 YAML frontmatter 和基础结构：

```markdown
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

## Workflow

[继续填充完整内容...]
```

---

### Task 2: 填充完整 skill 内容

**Files:**
- Modify: `skills/harness-health-check/SKILL.md`

按照 spec 设计，完整填充 skill 内容：

- [ ] **Step 1: 填充 Phase 1 - 项目复杂度评估**

```markdown
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
```

- [ ] **Step 2: 填充 Phase 2 - 动态检查标准**

```markdown
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
```

- [ ] **Step 3: 填充 Phase 3 - Harness 结构检查**

```markdown
### Phase 3: Harness 结构检查

检查 Harness 目录和文件的完整度。

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

| 检查项 | 严重程度（基于复杂度） |
|--------|------------------------|
| docs/harness/ 存在 | ERROR(高)/WARNING(中)/INFO(低) |
| docs/memory/ 存在 | WARNING(高)/INFO(中)/N/A(低) |
| docs/memory/execution-log/ 存在 | WARNING(高)/INFO(中)/N/A(低) |
| docs/checklists/ 存在 | ERROR(高)/WARNING(中)/N/A(低) |
| docs/rules/ 存在 | INFO |

**Level 3: 文档内容检查**

| 检查项 | 严重程度 |
|--------|----------|
| docs/memory/failure-patterns.md 存在且有模板 | WARNING |
| docs/memory/success-patterns.md 存在且有模板 | WARNING |
| docs/checklists/pre-task.md 存在 | WARNING |
| docs/checklists/code-review.md 存在 | WARNING |
| docs/checklists/post-task.md 存在 | WARNING |
| docs/harness/project-architecture.md 存在 | WARNING |
```

- [ ] **Step 4: 填充 Phase 4 - 规则一致性检查**

```markdown
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
```

- [ ] **Step 5: 填充输出格式和修复闭环**

```markdown
### Phase 5: 输出报告 + 修复闭环

输出结构化报告，包含当前状态、目标状态、差距、修复建议、下一步行动。

**报告格式：**

```markdown
## Harness Health Check Report

**Project:** [项目名称]
**复杂度评估:** 高（>200 文件，>8 贡献者，>10 业务模块）
**Checked:** YYYY-MM-DD HH:MM

### Summary
[ERROR/WARNING/INFO 计数表格]

### Errors
[每个 ERROR 的：当前状态 + 目标状态 + 差距 + 修复建议]

### Warnings
[每个 WARNING 的详情]

### Passed
[已满足的检查项]

### 不适用
[基于复杂度不需要的检查项]

---

## Next Actions

### 1. 立即修复（ERROR 级别）
[表格：行动 | 执行方式]

### 2. 计划修复（WARNING 级别）
[表格：行动 | 执行方式]

### 3. 验证修复
/harness-health-check

### 4. 持续监控
建议加入 CI/CD 流程
```
```

---

### Task 3: 添加 Quick Reference 和 Red Flags

**Files:**
- Modify: `skills/harness-health-check/SKILL.md`

- [ ] **Step 1: 添加 Quick Reference 表格**

```markdown
## Quick Reference

| 检查阶段 | 核心检查项 |
|----------|-----------|
| Phase 1 | 代码规模、团队规模、模块数量 |
| Phase 2 | 基于复杂度选择检查标准 |
| Phase 3 | AGENTS.md 行数、目录结构、文档内容 |
| Phase 4 | 预定义规则一致性检查（any 类型、组件结构等） |
| Phase 5 | 输出报告 + Next Actions 表格 |
```

- [ ] **Step 2: 添加 Red Flags 列表**

```markdown
## Red Flags

- 你跳过了项目复杂度评估，直接使用固定检查标准
- 你检查了低复杂度项目不需要的文档（如 failure-patterns.md）
- 你输出的报告没有"当前状态 + 目标状态 + 差距"结构
- 你没有提供可执行的 Next Actions 表格
- 你只检查了"文件在不在"，没有检查"规则是否被遵守"

**All red flags mean:** 重新审视检查流程，确保基于项目实际需求而非模板思维。
```

---

### Task 4: 完成 writing-skills 流程验证

- [ ] **Step 1: 按照 writing-skills workflow 完成验证**

遵循 writing-skills skill 的验证流程：
- RED Phase: 确认有实际证据（用户反馈的 AGENTS.md 行数问题）作为 baseline
- GREEN Phase: 验证 skill 内容覆盖所有 spec 要求
- REFACTOR Phase: 检查是否有遗漏或不一致

- [ ] **Step 2: 提交 skill 文件**

```bash
git add skills/harness-health-check/SKILL.md
git commit -m "feat: add harness-health-check skill for Harness environment compliance diagnostics

Features:
- Project complexity assessment (files, authors, modules)
- Dynamic check standards based on complexity
- AGENTS.md structure validation (line count, symlink, index)
- Rule consistency check with predefined mapping table
- Structured output with fix recommendations and Next Actions"
```

---

## 自检结果

**1. Spec coverage:**
- ✅ Phase 1 项目复杂度评估 → Task 2 Step 1
- ✅ Phase 2 动态检查标准 → Task 2 Step 2
- ✅ Phase 3 Harness 结构检查 → Task 2 Step 3
- ✅ Phase 4 规则一致性检查 → Task 2 Step 4
- ✅ Phase 5 输出报告 + 修复闭环 → Task 2 Step 5
- ✅ Quick Reference → Task 3 Step 1
- ✅ Red Flags → Task 3 Step 2

**2. Placeholder scan:** ✅ 无 TBD、TODO 或模糊描述

**3. Type consistency:** ✅ 无类型冲突（纯文档创建）

---

## 注意事项

**IRON LAW:** 此任务涉及 skill 文件创建，必须通过 `superpowers:writing-skills` skill 执行，遵循 TDD 流程验证。