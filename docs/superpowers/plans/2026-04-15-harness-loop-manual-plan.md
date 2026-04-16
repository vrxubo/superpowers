# Harness Loop Manual Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 `harness-loop.md` 从极简流程图升级为中文完整手册，覆盖 Harness 环境搭建、维护与自我演化。

**Architecture:** 采用“生命周期 + 角色视角”结构，按“搭建（细粒度）→维护（中粒度）→演化（策略粒度）”组织内容。每个主章节统一使用“原则、步骤、验收、故障、下一步”模板，并通过附录提供快速入口与 FAQ。

**Tech Stack:** Markdown、现有 Superpowers 文档与脚本引用

---

### Task 1: 重构主文档骨架

**Files:**
- Modify: `harness-loop.md`
- Reference: `docs/superpowers/specs/2026-04-15-harness-loop-design.md`

- [ ] **Step 1: 读取当前文档与设计规范**

Run: `ReadFile harness-loop.md` 与 `ReadFile docs/superpowers/specs/2026-04-15-harness-loop-design.md`  
Expected: 明确当前缺口与目标章节结构

- [ ] **Step 2: 写入新版目录与文档定位部分**

将 `harness-loop.md` 改写为完整目录：定位、心智模型、三大章节、附录。  
Expected: 文档从 7 行升级为可导航手册结构

- [ ] **Step 3: 自检结构一致性**

Run: 人工检查标题层级与顺序  
Expected: 与 spec 一致，无缺节、无重复节

### Task 2: 补全“搭建/维护/演化”三段内容

**Files:**
- Modify: `harness-loop.md`
- Reference: `docs/checklists/hook-configuration.md`
- Reference: `.cursor/hooks/harness-post-task.sh`

- [ ] **Step 1: 写“搭建”细粒度步骤与验收**

包含 Step 0-5、关键路径、完成信号、常见故障。  
Expected: 新手可直接按步骤完成最小 Harness 环境

- [ ] **Step 2: 写“维护”中粒度流程与检查点**

覆盖任务前/中/后与周检查。  
Expected: 读者可据此执行稳定运营，不依赖口头经验

- [ ] **Step 3: 写“自我演化”策略框架**

覆盖触发条件、决策树、节奏与反模式。  
Expected: 演化动作可追溯到证据，而非主观拍脑袋

### Task 3: 增补附录与最终校验

**Files:**
- Modify: `harness-loop.md`

- [ ] **Step 1: 增补“快速入口 / FAQ / 术语表”**

Expected: 三类读者都能快速定位下一步行动

- [ ] **Step 2: 占位符与歧义扫描**

Run: `rg "TODO|TBD|待补|后续补充" harness-loop.md`  
Expected: 无匹配

- [ ] **Step 3: 完整阅读与交付说明**

Run: `ReadFile harness-loop.md`  
Expected: 语言统一中文、结构完整、执行路径闭环清晰
