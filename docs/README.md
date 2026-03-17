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
定义项目开发标准和最佳实践，Cursor 自动加载对应规范。

### 2. Skills (技能)
特定领域的专家知识库，包含：
- **SKILL.md** - 技能核心定义
- **scripts/** - 可执行脚本
- **references/** - 参考文档
- **assets/** - 配置模板

### 3. Agents (代理)
专业领域的 AI 助手，处理特定任务。

### 4. Prompts (提示词)
针对开发场景的提示词模板，直接复制使用。

---

## 目录详解

### 1. .cursor/ - Cursor IDE 配置

#### 1.1 rules/ - 开发规范

提供各技术栈的开发规范和最佳实践。

| 文件 | 说明 | 核心内容 |
|-----|------|----------|
| `react.mdc` | React 19 开发规范 | use()/Actions/useOptimistic |
| `vue3.mdc` | Vue 3 开发规范 | Composition API/Pinia/VueUse |
| `nextjs.mdc` | Next.js 开发规范 | Server Actions/PPR/Suspense |
| `nestjs.mdc` | NestJS 开发规范 | Standalone/Signal/DI |
| `python-fastapi.mdc` | FastAPI 开发规范 | Pydantic v2/SQLAlchemy 2.0 |
| `go.mdc` | Go 开发规范 | 并发/接口/错误处理 |
| `rust.mdc` | Rust 开发规范 | 所有权/生命周期/并发 |
| `python-data.mdc` | Python 数据科学 | Pandas/NumPy/ML |
| `typescript.mdc` | TypeScript 规范 | 类型/泛型/Utility Types |
| `git.mdc` | Git 规范 | 分支管理/提交规范 |
| `dockerfile.mdc` | Dockerfile 规范 | 多阶段构建/镜像优化 |
| `kubernetes.mdc` | K8s 规范 | Deployment/Service/Ingress |
| `linux.mdc` | Linux 规范 | 命令行/Shell/系统管理 |
| `mongodb.mdc` | MongoDB 规范 | Mongoose/聚合/索引 |
| `api-design.mdc` | API 设计规范 | RESTful/GraphQL/版本控制 |
| `testing.mdc` | 测试规范 | Vitest/Playwright/RTL |
| `project.mdc` | 通用项目规范 | Git/TypeScript/AI 辅助 |

**子目录索引：**
- `frontend/typescript.mdc` - 前端 TypeScript 规范
- `backend/` - 后端规范索引
- `devops/` - DevOps 规范索引
- `ai/` - AI 规范索引

#### 1.2 skills/ - 专业技能

技能是完整的知识体系，包含脚本、文档和配置。

**前端技能：**

| 目录 | 说明 | 核心内容 |
|-----|------|----------|
| `frontend/state/` | 状态管理 | Zustand/Jotai/TanStack Query |
| `frontend/ui/` | UI 组件库 | Radix/Shadcn/Tailwind CSS |
| `frontend/css/` | CSS 框架 | Tailwind/CSS Modules/Styled |

**后端技能：**

| 目录 | 说明 | 核心内容 |
|-----|------|----------|
| `backend/auth/` | 认证授权 | JWT/Session/OAuth2/RBAC |
| `backend/orm/` | ORM 使用 | Prisma/Drizzle/SQLAlchemy |
| `backend/cache/` | 缓存策略 | Redis/Memcached/分布式锁 |

**DevOps 技能：**

| 目录 | 说明 | 核心内容 |
|-----|------|----------|
| `devops/ci-cd/` | CI/CD 流水线 | GitHub Actions/GitLab CI/Jenkins |
| `devops/monitoring/` | 监控告警 | Prometheus/Grafana/Sentry |
| `devops/infra/` | 基础设施 | Terraform/Ansible/AWS |
| `docker/` | Docker 容器化 | Dockerfile/Compose/优化 |
| `deploy/` | 部署运维 | PM2/Nginx/自动化部署 |
| `mobile/` | 移动端开发 | React Native/Flutter |

**AI 技能：**

| 目录 | 说明 | 核心内容 |
|-----|------|----------|
| `ai/llm/` | LLM 应用 | OpenAI/Claude/提示词工程 |
| `ai/rag/` | RAG 系统 | LangChain/向量数据库/文档分割 |
| `ai/agent/` | AI Agent | 工具调用/记忆机制/ReAct |

**通用技能：**

| 目录 | 说明 | 核心内容 |
|-----|------|----------|
| `database/` | 数据库优化 | 索引/N+1/分库分表 |
| `security/` | 安全加固 | OWASP/JWT/加密 |
| `testing/` | 测试工程 | Vitest/Playwright/测试策略 |
| `performance/` | 性能优化 | Core Web Vitals/缓存/懒加载 |
| `code-review/` | 代码审查 | 审查清单/最佳实践 |
| `mobile/` | 移动端开发 | React Native/Flutter/原生模块 |

#### 1.3 agents/ - 子代理

专业领域的 AI 助手。

| 文件 | 角色 | 工作范围 |
|-----|------|----------|
| `architect.md` | 系统架构师 | 系统设计/技术选型 |
| `bug-hunter.md` | Bug 猎人 | 错误分析/根因定位 |
| `code-review.md` | 代码审查员 | 代码审查/优化建议 |
| `data-engineer.md` | 数据工程师 | 数据管道/ETL/数据仓库 |
| `database-administrator.md` | DBA | 数据库设计/优化/运维 |
| `debugger.md` | 调试专家 | 断点调试/日志分析 |
| `devops-engineer.md` | DevOps | CI/CD/容器化/自动化 |
| `fullstack-developer.md` | 全栈工程师 | 前端+后端整体开发 |
| `product-manager.md` | 产品经理 | 需求分析/产品设计 |
| `refactor.md` | 重构专家 | 代码重构/设计优化 |
| `security-expert.md` | 安全专家 | 安全审计/漏洞修复 |
| `technical-writer.md` | 技术写作者 | 文档撰写/API 文档 |
| `test-generator.md` | 测试工程师 | 单元测试/E2E 测试 |
| `ui-designer.md` | UI/UX 设计师 | 界面设计/交互设计 |

#### 1.4 hooks.json - 自动化钩子

在特定事件触发时自动执行脚本：

| 钩子 | 触发时机 | 功能 |
|-----|----------|------|
| format-on-save | 保存文件后 | 自动格式化 (Prettier) |
| lint-on-save | 保存文件后 | 自动修复 (ESLint) |
| typecheck | 提交前 | 类型检查 (TypeScript) |
| test-before-commit | 提交前 | 运行测试 |

#### 1.5 mcp.json - MCP 服务器

MCP (Model Context Protocol) 扩展 AI 能力：

| 服务器 | 功能 |
|--------|------|
| filesystem | 文件系统操作 |
| git | Git 版本控制 |
| puppeteer | 浏览器自动化 |
| postgres | PostgreSQL 数据库 |
| sqlite | SQLite 数据库 |
| search | 代码搜索 |
| sentry | 错误监控 |

---

### 2. ai-tools/ - AI 工具推荐

按类别整理的 AI 开发工具。

| 文件 | 类别 | 主要内容 |
|-----|------|----------|
| `01-development-tools.md` | 开发工具 | Cursor/Windsurf/Zed/GitHub Copilot |
| `02-design-creative.md` | 设计创意 | Figma/v0/Midjourney/Runway |
| `03-writing-content.md` | 写作内容 | Jasper/Notion/DeepL |
| `04-productivity.md` | 效率工具 | Linear/Miro/Zapier |
| `05-audio-video.md` | 音视频 | ElevenLabs/CapCut |
| `06-global-saas.md` | 全球 SaaS | 主流 AI 产品 |
| `08-ai-platforms-api.md` | API 平台 | OpenAI/Anthropic/向量库 |
| `11-china-ai-tools.md` | 国内 AI | 文心一言/通义/豆包 |

---

### 3. prompts/ - 场景提示词

针对开发场景的提示词模板。

**通用场景 (01-06)：**

| 文件 | 场景 | 用途 |
|-----|------|------|
| `01-project-init.md` | 项目初始化 | 需求分析/技术选型 |
| `02-ui-design.md` | UI 设计 | 组件设计/样式 |
| `03-bug-fix.md` | Bug 修复 | 调试/错误分析 |
| `04-code-generation.md` | 代码生成 | 完整功能开发 |
| `05-refactor-optimize.md` | 重构优化 | 代码重构/性能优化 |
| `06-unit-testing.md` | 单元测试 | 测试编写/覆盖率 |

**专业场景 (07-13)：**

| 文件 | 场景 | 用途 |
|-----|------|------|
| `07-devops.md` | DevOps | Docker/CI/CD |
| `08-backend.md` | 后端开发 | 数据库/API/缓存 |
| `09-security.md` | 安全认证 | 权限/加密/防护 |
| `10-performance.md` | 性能优化 | 前端/后端/数据库 |
| `11-testing.md` | 测试工程 | E2E/集成测试 |
| `12-code-review.md` | 代码审查 | 审查要点/最佳实践 |
| `13-documentation.md` | 文档生成 | API/README/注释 |

**垂直场景 (14-15)：**

| 文件 | 场景 | 用途 |
|-----|------|------|
| `14-data-analysis.md` | 数据分析 | 数据处理/可视化 |
| `15-ai-app.md` | AI 应用 | LLM/Agent/RAG |

**技术栈提示词：**

| 文件 | 用途 |
|-----|------|
| `frontend.md` | 前端开发 |
| `backend.md` | 后端开发 |
| `ai.md` | AI 开发 |
| `devops.md` | DevOps |

---

### 4. docs/ - 项目文档

项目说明文档目录。

---

## 快速使用指南

### 在 Cursor 中使用 Rules

```markdown
@react           # React 规范
@nestjs          # NestJS 规范
@python-fastapi  # FastAPI 规范
```

### 在 Cursor 中使用 Skills

```markdown
/skill frontend-state   # 状态管理
/skill backend-auth     # 认证授权
/skill ai-llm          # LLM 应用
```

### 在 Cursor 中使用 Agents

```markdown
@architect          # 架构师
@bug-hunter        # Bug 猎人
@security-expert    # 安全专家
```

### 在提示词中使用 Prompts

```markdown
@prompts/04-code-generation  # 代码生成
@prompts/09-security        # 安全认证
```

### 在提示词中使用 AI Tools

```markdown
@ai-tools/01-development-tools  # 开发工具
@ai-tools/08-ai-platforms-api  # API 平台
```

---

## 项目统计

| 类别 | 数量 |
|------|------|
| Rules 规范 | 20+ |
| Skills 技能 | 18+ |
| Agents 代理 | 14+ |
| Prompts 提示词 | 20+ |
| AI Tools 工具 | 11 |

---

## 常见问题

**Q: 如何添加新的规范？**
A: 在 `.cursor/rules/` 下创建 `.mdc` 文件，遵循 Cursor 规则格式。

**Q: 如何创建自定义技能？**
A: 在 `.cursor/skills/` 下创建目录，包含 SKILL.md 和必要的脚本/文档。

**Q: 如何使用 MCP 服务器？**
A: 在 `.cursor/mcp.json` 中配置，Cursor 会自动加载。

---

## 贡献指南

欢迎提交 PR 补充：
- 新的技术栈规范
- 专业的技能
- 实用的代理
- 高效的提示词
- 精选的工具

---

## 许可证

MIT License
