# Harness Health Check Skill Design

## Overview

诊断项目的 Harness 环境是否符合实际需求，基于项目复杂度动态调整检查标准，解析 AGENTS.md 提取规则定义并检查代码遵守情况，提供结构化的修复闭环。

**Core principle:** 
- AGENTS.md 应控制在 100-150 行。超过 200 行，Agent 的注意力就会被稀释
- 检查的是"这个项目当前的状态，离它应该达到的状态还差什么"，不是"离预设模板还差什么"

## When to Use

- 用户显式调用 `/harness-health-check` 检查当前项目
- 对项目 Harness 环境合规性存疑时
- `harness-knowledge-discovery` 或 `project-standards-authoring` 执行后验证结果

## Workflow

### Phase 1: 项目复杂度评估

评估维度：

| 维度 | 低复杂度 | 中复杂度 | 高复杂度 |
|------|----------|----------|----------|
| 代码规模（src/ 文件数） | < 100 | 100-500 | > 500 |
| 团队规模（git 作者数） | < 3 | 3-10 | > 10 |
| 模块数量（业务模块目录数） | < 5 | 5-15 | > 15 |

综合评分：取最高维度决定整体复杂度等级。

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

检查 Harness 目录和文件的完整度。

### Phase 4: 规则一致性检查

**解析 AGENTS.md 提取规则定义：**

1. 读取 AGENTS.md 内容
2. 识别规则定义区块（如 "## 编码规范"、"### TypeScript 规范" 等）
3. 提取具体规则项（如 "禁止使用 any"、"组件结构必须包含 index.tsx" 等）
4. 将规则转换为可检查的模式

**常见规则检查项：**

| 检查项 | 数据来源 | 检查方式 |
|--------|----------|----------|
| 违规使用 any 类型 | grep `": any"` src/ | 计数违规文件数 |
| 组件结构不符合规范 | 扫描组件目录 | 检查 index.tsx + index.module.scss |
| 服务层使用非 POST 方法 | 扫描 src/services/ | 检查 HTTP 方法 |
| 类型定义位置违规 | 扫描 interface/type 定义位置 | 检查是否在 @/types/ |
| 目录结构约束 | 扫描 import 路径 | 检查跨层 import |

### Phase 5: 输出报告 + 修复闭环

## Output Format

```markdown
## Harness Health Check Report

**Project:** [项目名称]
**复杂度评估:** 高（>500 文件，>10 贡献者，>15 业务模块）
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
  - **修复建议**: 将规则详情移至 `docs/rules/`，AGENTS.md 只保留索引表格

- ❌ **违规使用 any 类型**: 23 个文件
  - **规则来源**: AGENTS.md "## TypeScript 规范 - 禁止使用 any"
  - **违规文件**: 
    - src/views/UserProfile/index.tsx (5处)
    - src/services/api.ts (8处)
    - ...
  - **修复建议**: 将 any 替换为具体类型或 unknown

### Warnings（高复杂度项目推荐项）

- ⚠️ **failure-patterns.md 缺失**
  - **当前状态**: 不存在
  - **目标状态**: 存在并有模板
  - **差距**: 需创建文件
  - **修复建议**: 创建 `docs/memory/failure-patterns.md` 并添加模板

### Passed（已满足项）

- ✅ `docs/checklists/` 存在（高复杂度必须项，已满足）
- ✅ `docs/harness/project-architecture.md` 存在（已满足）

### 不适用（低复杂度项目才需要）

- N/A `docs/memory/execution-log/` - 高复杂度项目当前阶段暂不需要

---

## Next Actions

### 1. 立即修复（ERROR 级别）

| 行动 | 执行方式 |
|------|----------|
| 精简 AGENTS.md | 手动编辑，将规则详情移至 docs/rules/index.md |
| 修复 any 类型违规 | 运行 `grep -r ": any" src/` 定位，逐文件替换 |

### 2. 计划修复（WARNING 级别）

| 行动 | 执行方式 |
|------|----------|
| 创建 failure-patterns.md | 运行 `/harness-knowledge-discovery` 或手动创建 |

### 3. 验证修复

```bash
# 修复后重新运行 Health Check
/harness-health-check
```

### 4. 持续监控

建议将 Health Check 加入 CI/CD 流程，每次 PR 自动检查 Harness 环境合规性。
```

## Skill Metadata

```yaml
name: harness-health-check
description: Use when diagnosing Harness environment compliance — evaluates project complexity, checks AGENTS.md rules consistency with actual code, and provides actionable fix recommendations with next steps
```

## File Structure

```
skills/harness-health-check/
└── SKILL.md              # Main skill document
```

## Check Items Detail

### Level 1: 项目复杂度评估

**代码规模检查：**
```bash
find src -type f | wc -l
```

**团队规模检查：**
```bash
git log --format='%aN' | sort -u | wc -l
```

**模块数量检查：**
```bash
# 根据项目结构调整，如 React 项目检查 src/views/ 目录数
find src/views -mindepth 1 -maxdepth 1 -type d | wc -l
```

### Level 2: AGENTS.md 检查

| 检查项 | 严重程度 | 检查方式 |
|--------|----------|----------|
| 文件存在 | ERROR | 检查 AGENTS.md 或 CLAUDE.md |
| 行数 ≤ 200 | ERROR | `wc -l AGENTS.md` |
| 行数 ≤ 150 | WARNING | `wc -l AGENTS.md` |
| 符号链接正确 | ERROR | 检查 AGENTS.md 是否是 CLAUDE.md 的 symlink |
| Core Index 表格存在 | ERROR | grep "When you need" |
| standards-index 区域为空 | WARNING | 检查 BEGIN/END 标记间内容 |

### Level 3: 目录结构检查

基于复杂度动态判断严重程度。

### Level 4: 规则一致性检查

**AGENTS.md 规则解析流程：**

1. 识别规则区块标识符（markdown heading patterns）
2. 提取规则项（bullet list items）
3. 将规则文本转换为 grep pattern 或文件结构检查
4. 执行检查，统计违规数量

**内置规则检查模板：**

| 规则文本 | grep pattern | 说明 |
|----------|--------------|------|
| "禁止使用 any" | `: any` | TypeScript any 类型 |
| "禁止使用 var" | `var ` | ES5 var 声明 |
| "必须使用单引号" | `"[^"]*"` (排除 JSON) | 字符串引号 |
| "组件必须包含 index.tsx" | 目录结构检查 | 组件目录完整性 |

## Future Iterations

- 支持 AGENTS.md 规则自定义检查模板
- 检查 Hook 配置（`.cursor/hooks.json`）
- 支持 CLI 输出格式（JSON/YAML）便于 CI 集成
- 支持增量检查（只检查变更文件）
- 生成修复 PR 的自动化 workflow