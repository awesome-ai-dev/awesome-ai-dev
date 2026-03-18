# AI 辅助开发最佳实践

> 一个帮助你系统化管理 AI 开发配置的开源项目

---

## 项目简介

### 解决的问题

用 AI 辅助开发时，你是否遇到过这些问题：

- **每次都要重复说同样的话** — "用 TypeScript"、"注意暗色模式"、"用 Tailwind"
- **好的实践没法传承** — 踩过的坑、学到的技巧，用完就忘了
- **团队配置不统一** — 每个人都要从头配置
- **新项目要从零开始** — 好的规范和提示词无法复用

### 项目目标

本项目的目标是帮助开发者：

1. **系统化管理 AI 配置** — 把规范、技能、代理、提示词集中管理
2. **传承开发经验** — 把踩过的坑、学到的技巧沉淀下来
3. **提升团队效率** — 配置文件提交 Git，团队共享复用
4. **降低 AI 使用门槛** — 提供开箱即用的提示词模板

### 核心价值

| 价值 | 说明 |
| ------ | ------ |
| **减少重复** | 一次配置，长期生效 |
| **团队共享** | 配置文件提交 Git，团队复用 |
| **知识沉淀** | 踩过的坑、学到的技巧都能沉淀下来 |
| **质量保证** | 规范化的代码质量更可控 |

---

## 项目提供什么

本项目提供完整的 AI 开发配置方案，包括三大核心模块：

| 模块 | 说明 | 数量 |
| ------ | ------ | ------ |
| **`.cursor/`** | Cursor IDE 完整配置 | 50+ |
| **`ai-tools/`** | AI 工具推荐合集 | 11 |
| **`prompts/`** | 场景化提示词库 | 20+ |

---

## 核心概念

在开始之前，先了解五个核心概念：

```
┌─────────────────────────────────────────────────────────┐
│                    你的 AI 开发系统                       │
├─────────────────────────────────────────────────────────┤
│  Rules ──→ 项目规范 (这个项目要怎么做)                    │
│  Skills ──→ 专业技能 (这个领域要怎么做)                   │
│  Agents ──→ 专业助手 (谁来做这件事)                       │
│  MCP   ──→ 扩展能力 (AI能做什么)                         │
│  Hooks ──→ 自动化 (保存/提交时自动执行)                   │
└─────────────────────────────────────────────────────────┘
```

### 1. Rules — 项目规范

Rules 告诉 AI "这个项目要怎么做"。比如用 Next.js 时，AI 应该知道：

- 用 App Router 结构
- Server Components 是默认
- 暗色模式用 dark: 前缀
- API 错误格式统一

### 2. Skills — 专业技能

Skills 是特定领域的专家知识库。比如你经常让 AI 写数据库代码，可以创建一个"数据库专家"Skill，AI 就会用专家的角度来回答。

### 3. Agents — AI 助手

Agents 是专业领域的 AI 助手，处理特定任务。每个 Agent 都有明确的工作范围和输出格式，比如代码审查代理、架构师代理等。

### 4. MCP — 扩展能力

MCP（Model Context Protocol）是 AI 的"USB接口"。以前 AI 只能跟你"聊天"，现在 AI 可以：

- 读取你电脑上的文件
- 执行终端命令
- 操作数据库
- 控制浏览器

### 5. Hooks — 自动化

Hooks 在特定事件触发时自动执行脚本，比如保存文件时自动格式化、提交前运行测试等。

---

## 快速开始

### 1. 复制配置到你的项目

```bash
# 复制完整配置
cp -r .cursor 你的项目/

# 或者只复制需要的部分
cp .cursor/rules/react.mdc 你的项目/.cursor/rules/
```

### 2. 使用

```text
# 使用规范
@react
帮我写个登录组件

# 使用技能
/skill database
如何优化这个查询？

# 使用代理
@code-review
帮我审查这段代码
```

---

## 核心模块详解

### .cursor — IDE 配置

```
.cursor/
├── rules/          # 开发规范 (20+)
├── skills/         # 专业技能 (15+)
├── agents/         # AI 助手 (14)
├── mcp.json        # MCP 配置
└── hooks.json      # 自动化脚本
```

**Rules 涵盖框架：**

| 框架 | 说明 |
|------|------|
| React | React 19 开发规范 |
| Vue | Vue 3 开发规范 |
| Next.js | Next.js 15 开发规范 |
| NestJS | NestJS 开发规范 |
| FastAPI | FastAPI + Pydantic v2 |
| Go | Go 开发规范 |
| Rust | Rust 开发规范 |
| TypeScript | TypeScript 规范 |
| Docker | Dockerfile 最佳实践 |
| Kubernetes | K8s 部署规范 |

**Skills 涵盖领域：**

| 领域 | 说明 |
|------|------|
| 前端 | 状态管理、UI 组件、CSS 框架 |
| 后端 | 认证授权、ORM 使用、缓存策略 |
| DevOps | Docker、CI/CD、监控、部署 |
| AI | LLM 应用、RAG 系统、Agent 开发 |
| 通用 | 数据库优化、安全加固、性能优化、测试工程 |

**Agents 涵盖角色：**

| Agent | 角色 |
|-------|------|
| architect | 系统架构师 |
| code-review | 代码审查员 |
| bug-hunter | Bug 猎人 |
| refactor | 重构专家 |
| test-generator | 测试工程师 |
| security-expert | 安全专家 |
| product-manager | 产品经理 |
| ui-designer | UI 设计师 |
| technical-writer | 技术写手 |

### ai-tools — AI 工具推荐

```
ai-tools/
├── 索引.md              # 工具索引
├── 开发工具.md          # 开发工具
├── 设计创意.md          # 设计创意
├── 写作内容.md          # 写作内容
├── 效率工具.md          # 效率工具
├── 音视频.md           # 音视频
├── 全球SaaS.md         # 全球 SaaS
├── AI平台API.md         # AI 平台
├── 垂直行业.md          # 垂直行业
├── 创业想法.md          # 创业想法
└── 国内AI工具.md        # 中国 AI 工具
```

**涵盖类别：**

| 类别 | 内容 |
|------|------|
| 开发工具 | Cursor、Windsurf、Zed、GitHub Copilot |
| 设计创意 | Figma、v0、Midjourney、Runway |
| 写作内容 | Jasper、Notion AI、DeepL |
| AI 平台 | OpenAI、Anthropic、Google AI |
| 国内 AI | 文心一言、通义千问、豆包 |

### prompts — 场景提示词

```
prompts/
├── 索引.md               # 提示词索引
├── 项目初始化.md         # 项目初始化
├── UI设计.md            # UI 设计
├── Bug修复.md           # Bug 修复
├── 代码生成.md          # 代码生成
├── 重构优化.md          # 重构优化
├── 单元测试.md          # 单元测试
├── DevOps.md            # DevOps
├── 后端开发.md          # 后端开发
├── 安全认证.md          # 安全认证
├── 性能优化.md          # 性能优化
├── 测试工程.md          # 测试工程
├── 代码审查.md          # 代码审查
├── 文档生成.md          # 文档生成
├── 数据分析.md          # 数据分析
└── AI应用.md            # AI 应用
```

**使用方式：**

```text
@prompts/项目初始化  # 初始化项目
@prompts/AI应用     # AI 应用开发
```

---

## 项目统计

| 类别 | 数量 | 说明 |
|------|------|------|
| Rules 规范 | 20+ | 覆盖主流框架和通用技术 |
| Skills 技能 | 15+ | 包含脚本、文档、配置 |
| Agents 代理 | 14 | 专业领域的 AI 助手 |
| Prompts 提示词 | 20+ | 场景化开发提示词 |
| AI Tools 工具 | 11 | 按类别整理的 AI 工具 |

---

## 相关资源

| 资源 | 说明 |
|------|------|
| [AI 工具推荐](./ai-tools/) | 各类 AI 工具合集 |
| [场景提示词](./prompts/) | 开发场景提示词 |
| [详细文档](./docs/) | 项目详细说明 |

---

## 下一步

1. **复制配置** — 把 `.cursor/` 复制到你的项目
2. **选择工具** — 查看 `ai-tools/` 选择合适的 AI 工具
3. **使用提示词** — 在 `prompts/` 中找到对应场景

把配置复制到你的项目，体验 AI 辅助开发的便利吧！

---

## 常见问题

**Q: 这个项目只能用于 Cursor 吗？**

A: 项目主要针对 Cursor IDE，但 Rules、Skills、Prompts 的概念在其他 AI 工具中也适用，只是配置方式不同。

**Q: 如何添加新的规范？**

A: 在 `.cursor/rules/` 下创建 `.mdc` 文件，遵循 Cursor 规则格式。

**Q: 项目中的提示词如何使用？**

A: 直接复制 `prompts/` 目录下的提示词到你的 AI 对话中，根据实际情况修改参数。

**Q: 如何贡献代码？**

A: 欢迎提交 PR 补充新的规范、技能、代理、提示词或工具。详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

---

## 开源信息

### 许可证

本项目采用 MIT 许可证，详见 [LICENSE](./LICENSE)。

### 贡献指南

欢迎贡献！详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

### 联系方式

- Gitee: https://gitee.com/awesome-ai-dev/awesome-ai-dev
- GitHub: https://github.com/awesome-ai-dev/awesome-ai-dev
- 提交 Issue: https://github.com/awesome-ai-dev/awesome-ai-dev/issues
- 提交 PR: https://github.com/awesome-ai-dev/awesome-ai-dev/pulls

---

**让 AI 开发变得更简单！** 🚀
