# AI 辅助开发项目文档

> 完整的 AI 辅助开发方法论与工具集

---

## 项目简介

本项目旨在帮助开发者利用 AI 工具提升开发效率，提供从规范制定、技能学习、代理协作到提示词模板的完整解决方案。项目涵盖前端、后端、DevOps、AI 四大技术方向，是 AI 辅助开发的最佳实践指南。

---

## 目录结构

```
ai-summary/
├── .cursor/              # Cursor IDE 配置
│   ├── rules/            # 开发规范 (20+)
│   ├── skills/           # 专业技能 (18+)
│   ├── agents/           # 子代理 (14+)
│   ├── hooks.json        # 自动化钩子
│   └── mcp.json         # MCP 服务器
├── ai-tools/             # AI 工具推荐 (11)
├── prompts/              # 场景提示词 (20+)
├── docs/                 # 项目文档
└── README.md            # 项目主页
```

---

## 核心概念

### 1. Rules (规范)
定义项目开发标准和最佳实践，Cursor 自动加载对应规范。开发者无需手动复制粘贴规范内容，只需在提示词中引用即可。

### 2. Skills (技能)
特定领域的专家知识库，包含：
- **SKILL.md** - 技能核心定义，包含代码示例和最佳实践
- **scripts/** - 可执行脚本，用于自动化任务
- **references/** - 参考文档，提供深入的学习资料
- **assets/** - 配置模板，快速启动项目

### 3. Agents (代理)
专业领域的 AI 助手，处理特定任务。每个代理都有明确的工作范围和输出格式。

### 4. Prompts (提示词)
针对开发场景的提示词模板，直接复制使用即可获得最佳效果。

---

## 目录详解

### 1. .cursor/ - Cursor IDE 配置

Cursor 是 AI-First 的代码编辑器，本目录包含在 Cursor 中使用的所有配置。配置完成后，Cursor 会自动加载这些规范和技能。

#### 1.1 rules/ - 开发规范

提供各技术栈的开发规范和最佳实践。开发者只需在提示词中引用 `@react` 或 `@nestjs` 等，即可让 AI 使用对应的规范。

**框架规范：**

| 文件 | 说明 | 核心特性 |
|-----|------|----------|
| `react.mdc` | React 19 开发规范 | use() Hook / Actions / Server Actions / useOptimistic / 并发特性 |
| `vue3.mdc` | Vue 3 开发规范 | Composition API / Pinia / VueUse / Teleport / Suspense |
| `nextjs.mdc` | Next.js 开发规范 | Server Actions / Partial Prerendering (PPR) / Suspense / App Router |
| `nestjs.mdc` | NestJS 开发规范 | Standalone / Signal / 依赖注入 / GraphQL / 微服务 |
| `python-fastapi.mdc` | FastAPI 开发规范 | Pydantic v2 / SQLAlchemy 2.0 / 依赖注入 / WebSocket |
| `go.mdc` | Go 开发规范 | Goroutine / Channel / 接口 / 错误处理 / Context |
| `rust.mdc` | Rust 开发规范 | 所有权系统 / 生命周期 / 借用检查 / 并发 / Cargo |
| `python-data.mdc` | Python 数据科学 | Pandas / NumPy / Scikit-learn / Jupyter / 数据可视化 |

**通用规范：**

| 文件 | 说明 | 核心内容 |
|-----|------|----------|
| `typescript.mdc` | TypeScript 规范 | 类型系统 / 泛型 / Utility Types / 装饰器 / 类型守卫 |
| `git.mdc` | Git 规范 | 分支策略 / 提交规范 / 工作流 / Rebase / Cherry-pick |
| `dockerfile.mdc` | Dockerfile 规范 | 多阶段构建 / 镜像优化 / .dockerignore / 最佳实践 |
| `kubernetes.mdc` | K8s 规范 | Deployment / Service / Ingress / ConfigMap / Secret / HPA |
| `linux.mdc` | Linux 规范 | 命令行 / Shell 脚本 / 系统管理 / 进程管理 / 网络命令 |
| `mongodb.mdc` | MongoDB 规范 | Mongoose / 聚合管道 / 索引策略 / 副本集 / 分片 |
| `api-design.mdc` | API 设计规范 | RESTful / GraphQL / 状态码 / 版本控制 / 认证 |
| `testing.mdc` | 测试规范 | Vitest / Playwright / React Testing Library / 单元测试 / E2E |
| `project.mdc` | 通用项目规范 | 项目结构 / Git / TypeScript / ESLint / Prettier / AI 辅助开发 |

**子目录索引：**
- `frontend/typescript.mdc` - 前端 TypeScript 开发规范
- `backend/` - 后端开发规范索引（NestJS / FastAPI / Go / Python）
- `devops/` - DevOps 规范索引（Docker / K8s / CI/CD）
- `ai/` - AI 开发规范索引（LLM / RAG / Agent）

#### 1.2 skills/ - 专业技能

技能是完整的知识体系，包含脚本、文档和配置。使用 `/skill 技能名` 调用。

**前端技能：**

| 目录 | 说明 | 包含内容 |
|-----|------|----------|
| `frontend/state/` | 前端状态管理 | Zustand / Jotai / Redux / TanStack Query 的使用方法和最佳实践 |
| `frontend/ui/` | UI 组件库 | Radix UI / Shadcn UI / Tailwind CSS / Headless UI / 组件设计模式 |
| `frontend/css/` | CSS 框架 | Tailwind CSS / CSS Modules / Styled Components / PostCSS / 响应式设计 |

**后端技能：**

| 目录 | 说明 | 包含内容 |
|-----|------|----------|
| `backend/auth/` | 认证授权 | JWT / Session / OAuth2 / SSO / RBAC / ACL / 第三方登录 / 密码加密 |
| `backend/orm/` | ORM 使用 | Prisma / Drizzle / SQLAlchemy / 迁移策略 / 关系设计 / 软删除 |
| `backend/cache/` | 缓存策略 | Redis / Memcached / 分布式锁 / 缓存穿透 / 缓存雪崩 / CDN |

**DevOps 技能：**

| 目录 | 说明 | 包含内容 |
|-----|------|----------|
| `devops/ci-cd/` | CI/CD 流水线 | GitHub Actions / GitLab CI / Jenkins / 自动化测试 / 部署流程 |
| `devops/monitoring/` | 监控告警 | Prometheus / Grafana / Sentry / 日志收集 / 性能监控 / 告警规则 |
| `devops/infra/` | 基础设施 | Terraform / Ansible / AWS / GCP / 云服务 / 基础设施代码化 |
| `docker/` | Docker 容器化 | Dockerfile / Docker Compose / 镜像构建 / 容器网络 / 最佳实践 |
| `deploy/` | 部署运维 | PM2 / Nginx / 负载均衡 / SSL / CI/CD / 回滚策略 / 蓝绿部署 |
| `mobile/` | 移动端开发 | React Native / Flutter / 原生模块 / 打包发布 / App Store |

**AI 技能：**

| 目录 | 说明 | 包含内容 |
|-----|------|----------|
| `ai/llm/` | LLM 应用开发 | OpenAI / Claude / 提示词工程 / 流式输出 / 函数调用 / Token 优化 |
| `ai/rag/` | RAG 系统开发 | LangChain / 向量数据库 / 文档分割 / 检索优化 / Re-ranking / 混合搜索 |
| `ai/agent/` | AI Agent 开发 | OpenAI Agents SDK / 工具调用 / 记忆机制 / ReAct / 规划能力 |

**通用技能：**

| 目录 | 说明 | 包含内容 |
|-----|------|----------|
| `database/` | 数据库优化 | 索引设计 / N+1 查询 / 连接池 / 分库分表 / SQL 优化 / 主从复制 |
| `security/` | 安全加固 | OWASP Top 10 / JWT / HTTPS / CORS / CSP / XSS / CSRF / SQL 注入防护 |
| `testing/` | 测试工程 | Vitest / Playwright / Jest / RTL / 单元测试 / 集成测试 / E2E / 测试策略 |
| `performance/` | 性能优化 | Core Web Vitals / Lighthouse / 懒加载 / 代码分割 / 缓存策略 / SSR |
| `code-review/` | 代码审查 | 审查清单 / 最佳实践 / 代码质量 / 性能考量 / 安全检查 |
| `mobile/` | 移动端开发 | React Native / Flutter / iOS / Android / 原生模块 / 热更新 |

#### 1.3 agents/ - 子代理

专业领域的 AI 助手，每个代理都有明确的专业方向和工作范围。使用 `@代理名` 调用。

| 文件 | 角色 | 工作范围 | 输出内容 |
|-----|------|----------|----------|
| `architect.md` | 系统架构师 | 系统设计/技术选型/架构图 | 系统架构 / 技术选型 / 数据库设计 / API 设计 |
| `bug-hunter.md` | Bug 猎人 | 错误分析/根因定位/修复方案 | 错误原因 / 复现步骤 / 修复代码 / 预防措施 |
| `code-review.md` | 代码审查员 | 代码审查/优化建议/质量把控 | 审查意见 / 问题列表 / 优化建议 / 代码评分 |
| `data-engineer.md` | 数据工程师 | 数据管道/ETL/数据仓库 | 数据流程 / ETL 脚本 / 数据模型 / 调度策略 |
| `database-administrator.md` | DBA | 数据库设计/性能优化/运维 | 数据库设计 / 索引优化 / 备份策略 / 监控配置 |
| `debugger.md` | 调试专家 | 断点调试/日志分析/问题定位 | 调试策略 / 日志分析 / 断点设置 / 问题根因 |
| `devops-engineer.md` | DevOps 工程师 | CI/CD/容器化/自动化 | CI/CD 配置 / Dockerfile / 部署脚本 / 监控方案 |
| `fullstack-developer.md` | 全栈工程师 | 前端+后端整体开发 | 技术方案 / 前端代码 / 后端代码 / 部署说明 |
| `product-manager.md` | 产品经理 | 需求分析/产品设计/规划 | 需求文档 / 功能列表 / 优先级 / 时间线 |
| `refactor.md` | 重构专家 | 代码重构/设计优化/技术债务 | 重构计划 / 变更内容 / 测试策略 / 风险评估 |
| `security-expert.md` | 安全专家 | 安全审计/漏洞修复/防护 | 安全报告 / 漏洞修复 / 防护建议 / 加固方案 |
| `technical-writer.md` | 技术写作者 | 文档撰写/API 文档/注释 | 技术文档 / API 文档 / README / 注释规范 |
| `test-generator.md` | 测试工程师 | 单元测试/E2E 测试/测试策略 | 测试用例 / 测试代码 / 覆盖率报告 / 测试计划 |
| `ui-designer.md` | UI/UX 设计师 | 界面设计/交互设计/用户体验 | 设计稿 / 组件规范 / 交互流程 / 设计系统 |

#### 1.4 hooks.json - 自动化钩子

在特定事件触发时自动执行脚本，减少重复性工作：

| 钩子 | 触发时机 | 功能 | 工具 |
|-----|----------|------|------|
| format-on-save | 保存文件后 | 自动格式化代码 | Prettier |
| lint-on-save | 保存文件后 | 自动修复 ESLint 错误 | ESLint --fix |
| typecheck | 提交前 | 运行 TypeScript 类型检查 | tsc --noEmit |
| test-before-commit | 提交前 | 运行测试确保代码正确 | vitest run |

#### 1.5 mcp.json - MCP 服务器

MCP (Model Context Protocol) 扩展 AI 能力，让 AI 能够与外部系统交互：

| 服务器 | 功能 | 用途 |
|--------|------|------|
| filesystem | 文件系统操作 | 读取/写入/搜索文件 |
| git | Git 版本控制 | 查看日志/提交/分支操作 |
| puppeteer | 浏览器自动化 | 网页截图/自动化测试 |
| postgres | PostgreSQL | 数据库查询/操作 |
| sqlite | SQLite | 轻量数据库操作 |
| search | 代码搜索 | 全局搜索/代码定位 |
| sentry | 错误监控 | 查看/分析线上错误 |

---

### 2. ai-tools/ - AI 工具推荐

按类别整理的 AI 开发工具，帮助开发者选择合适的工具提升效率。

**开发工具：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `01-development-tools.md` | 代码编辑器 | Cursor / Windsurf / Zed / GitHub Copilot / VS Code AI 插件 |

**创意设计：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `02-design-creative.md` | 设计创意 | Figma / v0 / Midjourney / Runway / Leonardo / Stable Diffusion |

**写作内容：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `03-writing-content.md` | 写作助手 | Jasper / Notion AI / DeepL / Grammarly / 写作辅助工具 |

**效率工具：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `04-productivity.md` | 效率提升 | Linear / Miro / Zapier / Monday / Asana / 项目管理工具 |

**音视频：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `05-audio-video.md` | 音视频处理 | ElevenLabs / CapCut / Descript / 语音合成/视频编辑 |

**全球 SaaS：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `06-global-saas.md` | 全球 AI 产品 | 主流 AI SaaS 产品汇总 |

**API 平台：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `08-ai-platforms-api.md` | API/模型平台 | OpenAI / Anthropic / Google AI / Azure / API 接入指南 |

**国内 AI：**

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `11-china-ai-tools.md` | 国内 AI 工具 | 文心一言 / 通义千问 / 豆包 / 智谱清言 / Moonshot |

---

### 3. prompts/ - 场景提示词

针对开发场景的提示词模板，直接复制使用即可获得最佳效果。每个提示词都经过优化，包含需求格式、技术要求、输出格式等。

**通用场景 (01-06)：**

| 文件 | 场景 | 用途 | 包含内容 |
|-----|------|------|----------|
| `01-project-init.md` | 项目初始化 | 新项目启动时的需求分析和技术选型 | 需求模板 / 技术选型 / 项目结构 / 初始化命令 |
| `02-ui-design.md` | UI 设计 | 组件设计、样式、交互实现 | 组件模板 / 样式方案 / 响应式设计 / 无障碍 |
| `03-bug-fix.md` | Bug 修复 | 错误分析、定位、修复 | 错误描述 / 分析步骤 / 修复代码 / 测试验证 |
| `04-code-generation.md` | 代码生成 | 完整功能开发 | 需求分析 / 代码实现 / 单元测试 / 使用示例 |
| `05-refactor-optimize.md` | 重构优化 | 代码重构和性能优化 | 重构目标 / 变更计划 / 代码变更 / 测试策略 |
| `06-unit-testing.md` | 单元测试 | 编写单元测试和测试用例 | 测试框架 / 测试用例 / Mock / 覆盖率 |

**专业场景 (07-13)：**

| 文件 | 场景 | 用途 | 包含内容 |
|-----|------|------|----------|
| `07-devops.md` | DevOps | Docker、CI/CD、部署配置 | Dockerfile / CI 配置 / 部署脚本 / 监控 |
| `08-backend.md` | 后端开发 | 数据库设计、API 开发、缓存 | 架构设计 / API 接口 / 数据库模型 / 业务逻辑 |
| `09-security.md` | 安全认证 | 权限控制、加密、安全防护 | 认证方案 / 权限设计 / 加密策略 / 安全加固 |
| `10-performance.md` | 性能优化 | 前端/后端/数据库性能优化 | 性能分析 / 优化方案 / 缓存策略 / 索引优化 |
| `11-testing.md` | 测试工程 | E2E 测试、集成测试、测试策略 | 测试计划 / E2E 测试 / 集成测试 / CI 集成 |
| `12-code-review.md` | 代码审查 | 代码审查要点和最佳实践 | 审查清单 / 评分标准 / 问题模板 / 改进建议 |
| `13-documentation.md` | 文档生成 | API 文档、README、注释 | 文档模板 / API 文档 / README / 注释规范 |

**垂直场景 (14-15)：**

| 文件 | 场景 | 用途 | 包含内容 |
|-----|------|------|----------|
| `14-data-analysis.md` | 数据分析 | 数据处理、可视化、报表 | 数据处理流程 / 可视化方案 / 报表设计 |
| `15-ai-app.md` | AI 应用开发 | LLM、Agent、RAG 应用开发 | 应用架构 / 提示词设计 / API 集成 / 部署方案 |

**技术栈提示词：**

| 文件 | 用途 | 包含内容 |
|-----|------|----------|
| `frontend.md` | 前端开发 | React / Vue / Next.js 开发提示词模板 |
| `backend.md` | 后端开发 | NestJS / FastAPI / Go 开发提示词模板 |
| `ai.md` | AI 开发 | LLM / RAG / Agent 开发提示词模板 |
| `devops.md` | DevOps | CI/CD / Docker / 监控配置提示词模板 |

---

### 4. docs/ - 项目文档

项目说明文档目录，包含本文件和项目使用指南。

---

## 快速使用指南

### 在 Cursor 中使用 Rules

在编写代码时，通过 `@` 符号引用规范文件：

```markdown
@react           # 使用 React 19 规范
@nestjs          # 使用 NestJS 规范
@python-fastapi  # 使用 FastAPI 规范
@typescript      # 使用 TypeScript 规范
@dockerfile      # 使用 Dockerfile 规范
```

### 在 Cursor 中使用 Skills

使用 `/skill` 命令调用技能：

```markdown
/skill frontend-state   # 调用状态管理技能
/skill backend-auth     # 调用认证授权技能
/skill ai-llm          # 调用 LLM 开发技能
/skill testing         # 调用测试技能
```

### 在 Cursor 中使用 Agents

使用 `@` 符号调用代理：

```markdown
@architect          # 让架构师设计系统
@bug-hunter        # 追踪 Bug
@code-review        # 进行代码审查
@security-expert    # 安全审计
@refactor           # 重构代码
```

### 在提示词中使用 Prompts

在编写提示词时引用：

```markdown
@prompts/04-code-generation  # 代码生成模板
@prompts/03-bug-fix         # Bug 修复模板
@prompts/09-security        # 安全认证模板
```

### 在提示词中使用 AI Tools

在选择工具时参考：

```markdown
@ai-tools/01-development-tools  # 开发工具推荐
@ai-tools/08-ai-platforms-api  # API 平台选择
@ai-tools/11-china-ai-tools    # 国内 AI 工具
```

---

## 项目统计

| 类别 | 数量 | 说明 |
|------|------|------|
| Rules 规范 | 20+ | 覆盖主流框架和通用技术 |
| Skills 技能 | 18+ | 包含脚本、文档、配置 |
| Agents 代理 | 14+ | 专业领域的 AI 助手 |
| Prompts 提示词 | 20+ | 场景化开发提示词 |
| AI Tools 工具 | 11 | 按类别整理的 AI 工具 |

---

## 常见问题

**Q: 如何添加新的规范？**
A: 在 `.cursor/rules/` 下创建 `.mdc` 文件，遵循 Cursor 规则格式。文件需要包含 name、description、globs 和 alwaysApply 字段。

**Q: 如何创建自定义技能？**
A: 在 `.cursor/skills/` 下创建目录，包含：
- SKILL.md - 技能定义
- scripts/ - 可执行脚本
- references/ - 参考文档
- assets/ - 配置模板

**Q: 如何使用 MCP 服务器？**
A: 在 `.cursor/mcp.json` 中配置服务器，Cursor 会自动加载并可以使用。

**Q: 如何让 AI 使用特定的规范？**
A: 在提示词中直接引用，例如：`@react` 或 `@nestjs`。

**Q: 项目中的提示词如何使用？**
A: 直接复制 `prompts/` 目录下的提示词到你的 AI 对话中，根据实际情况修改参数。

---

## 贡献指南

欢迎提交 PR 补充：
- 新的技术栈规范
- 专业的技能
- 实用的代理
- 高效的提示词
- 精选的工具

贡献前请确保：
1. 内容与现有文件不重复
2. 包含实际可用的代码示例
3. 有清晰的使用说明

---

## 许可证

MIT License
