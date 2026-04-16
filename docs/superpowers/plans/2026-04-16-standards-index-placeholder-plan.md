# standards-index 占位符改进实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:writing-skills` to implement this plan. This is a skill file modification, which requires the writing-skills workflow for evaluation and testing.

**Goal:** 消除 `harness-knowledge-discovery` skill 中 `standards-index` 区域的混淆设计，确保 Agent 正确留空等待 `project-standards-authoring` 填充。

**Architecture:** 移除冗余的 "Rules Sub-Index" 表格，只保留带明确中文注释的空 `standards-index` 区域，并新增 Red Flag 防止错误填充。

**Tech Stack:** Skill 文件修改，无代码依赖

---

## 文件结构

| 文件 | 操作 | 职责 |
|------|------|------|
| `skills/harness-knowledge-discovery/SKILL.md` | 修改 | 模板区域简化 + Red Flag 新增 |

---

### Task 1: 修改模板区域

**Files:**
- Modify: `skills/harness-knowledge-discovery/SKILL.md:155-162`

- [ ] **Step 1: 使用 writing-skills skill 开始修改**

启动 writing-skills workflow，声明修改目标：
- 修改文件：`skills/harness-knowledge-discovery/SKILL.md`
- 修改类型：编辑现有 skill
- 修改内容：简化模板区域，移除冗余表格，添加明确注释

- [ ] **Step 2: 定位并修改模板区域**

将第 155-162 行内容从：

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

- [ ] **Step 3: 验证修改正确性**

确认修改后：
- 无 "Rules Sub-Index" 表格残留
- `standards-index` 区域为空占位符
- 中文注释清晰明确

---

### Task 2: 新增 Red Flag

**Files:**
- Modify: `skills/harness-knowledge-discovery/SKILL.md` (Red Flags 章节)

- [ ] **Step 1: 在 Red Flags 列表末尾新增一条**

在现有 Red Flags 列表最后一行后添加：

```markdown
- 你在 `standards-index` 区域填充了任何内容（该区域应由 `project-standards-authoring` 填充）
```

- [ ] **Step 2: 验证 Red Flag 格式正确**

确认新增的 Red Flag：
- 与其他 Red Flag 格式一致
- 明确指出错误行为和正确做法

---

### Task 3: 完成修改并提交

- [ ] **Step 1: 按照 writing-skills workflow 完成验证**

遵循 writing-skills skill 的验证流程：
- 检查 skill 结构完整性
- 确认修改符合 skill 设计原则

- [ ] **Step 2: 提交修改**

```bash
git add skills/harness-knowledge-discovery/SKILL.md
git commit -m "fix: clarify standards-index placeholder in harness-knowledge-discovery

Remove redundant Rules Sub-Index table that caused agent confusion.
Add explicit Chinese comment and Red Flag to prevent premature filling."
```

---

## 自检结果

**1. Spec coverage:** ✅ 覆盖了 spec 中的所有修改点（模板区域 + Red Flag）

**2. Placeholder scan:** ✅ 无 TBD、TODO 或模糊描述

**3. Type consistency:** ✅ 无类型冲突（纯文档修改）

---

## 注意事项

**IRON LAW:** 此任务涉及 skill 文件修改，必须通过 `superpowers:writing-skills` skill 执行，不得直接编辑 `skills/**/SKILL.md` 文件。