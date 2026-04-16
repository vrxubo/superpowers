# standards-index 占位符设计改进

## 背景

执行 `harness-knowledge-discovery` skill 时，Agent 错误地将规则内容直接填充到了 `standards-index` 区域，而不是按照设计意图留空等待 `project-standards-authoring` 来填充。

### 问题根源

`harness-knowledge-discovery` 模板中同时存在两个元素：

```markdown
## Rules Sub-Index

|| Rule Type | File |
||---|---|
|| (populated by project-standards-authoring) | `docs/rules/` |

<!-- BEGIN standards-index -->
<!-- END standards-index -->
```

这种设计导致混淆：
- "Rules Sub-Index" 表格带注释说明由 `project-standards-authoring` 填充
- 但空的 `standards-index` 区域没有任何说明
- Agent 可能误认为需要在这两个区域之一填充内容

### 预期行为

根据 skill 设计意图：
- `harness-knowledge-discovery` 只创建空占位符
- `project-standards-authoring` 选择分类方案后填充索引表格

## 设计方案

### 方案选择

采用 **方案 A**：移除冗余的 "Rules Sub-Index" 表格，只保留带有明确注释的空 `standards-index` 区域。

### 修改内容

**文件：** `skills/harness-knowledge-discovery/SKILL.md`

**修改 1：模板区域（第 155-162 行）**

将：

```markdown
## Rules Sub-Index

|| Rule Type | File |
||---|---|
|| (populated by project-standards-authoring) | `docs/rules/` |

<!-- BEGIN standards-index -->
<!-- END standards-index -->
```

改为：

```markdown
<!-- BEGIN standards-index -->
<!-- 留空。由 project-standards-authoring skill 填充分类索引表格 -->
<!-- END standards-index -->
```

**修改 2：Red Flags 列表**

新增一条 Red Flag：

```markdown
- 你在 `standards-index` 区域填充了任何内容（该区域应由 `project-standards-authoring` 填充）
```

### 不修改的部分

`project-standards-authoring` skill 的设计是正确的，不需要改动。它已明确说明用索引表格格式填充 `standards-index` 区域。

## 影响范围

| 文件 | 修改类型 |
|------|----------|
| `skills/harness-knowledge-discovery/SKILL.md` | 模板修改 + Red Flag 新增 |

## 验证方式

重新执行 `harness-knowledge-discovery` skill，验证生成的 AGENTS.md 中 `standards-index` 区域为空占位符，不含任何规则内容。