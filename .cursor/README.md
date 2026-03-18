# .cursor 目录索引

> AI 辅助开发配置合集

## 目录结构

```text
.cursor/
├── rules/          # 开发规范 (.mdc 文件)
├── skills/         # 技能 (含 scripts/references/assets)
├── agents/         # 子代理 (.md 文件)
├── mcp.json        # MCP 配置
├── hooks.json      # 钩子配置
└── README.md      # 本索引文件
```

## Rules 索引

| 文件 | 说明 |
| --- | --- |
| project.mdc | 通用项目规范 |
| react.mdc | React 19 开发规范 |
| vue3.mdc | Vue 3 开发规范 |
| nextjs.mdc | Next.js 开发规范 |
| typescript.mdc | TypeScript 规范 |
| nestjs.mdc | NestJS 开发规范 |
| python-fastapi.mdc | FastAPI 开发规范 |
| go.mdc | Go 开发规范 |
| rust.mdc | Rust 开发规范 |
| mongodb.mdc | MongoDB 规范 |
| python-data.mdc | Python 数据科学 |
| dockerfile.mdc | Dockerfile 规范 |
| kubernetes.mdc | Kubernetes 规范 |
| linux.mdc | Linux 规范 |
| git.mdc | Git 规范 |
| api-design.mdc | API 设计规范 |
| testing.mdc | 测试规范 |

## Skills 索引

### AI 技能

| 技能 | 说明 |
| --- | --- |
| ai/llm | LLM 应用开发 |
| ai/rag | RAG 系统 |
| ai/agent | Agent 开发 |

### 前端技能

| 技能 | 说明 |
| --- | --- |
| frontend/state | 状态管理 |
| frontend/ui | UI 组件库 |
| frontend/css | CSS 框架 |

### 后端技能

| 技能 | 说明 |
| --- | --- |
| backend/auth | 认证授权 |
| backend/orm | ORM 使用 |
| backend/cache | 缓存策略 |

### DevOps 技能

| 技能 | 说明 |
| --- | --- |
| devops/ci-cd | CI/CD 流水线 |
| devops/monitoring | 监控告警 |
| devops/infra | 基础设施 |

### 专项技能

| 技能 | 说明 |
| --- | --- |
| database | 数据库优化 |
| testing | 测试工程 |
| security | 安全加固 |
| performance | 性能优化 |
| code-review | 代码审查 |
| docker | Docker 容器化 |
| deploy | 应用部署 |
| mobile | 移动端开发 |

## Agents 索引

| Agent | 说明 |
| --- | --- |
| architect | 架构师 |
| fullstack-developer | 全栈开发 |
| devops-engineer | DevOps 工程师 |
| data-engineer | 数据工程师 |
| security-expert | 安全专家 |
| test-generator | 测试工程师 |
| code-review | 代码审查员 |
| bug-hunter | Bug 追踪 |
| refactor | 重构专家 |
| debugger | 调试专家 |
| database-administrator | 数据库管理员 |
| product-manager | 产品经理 |
| technical-writer | 技术文档 |
| ui-designer | UI 设计师 |

## 使用方式

```bash
# 在 Cursor 中引用
@.cursor/rules/react      # 使用 React 规范
@.cursor/skills/database # 使用数据库技能
@.cursor/agents/architect # 调用架构师代理
```

## 配置文件说明

### mcp.json

MCP (Model Context Protocol) 服务器配置，支持多种工具集成：
- filesystem - 文件系统
- git - Git 操作
- puppeteer - 浏览器自动化
- postgres - PostgreSQL 数据库
- sqlite - SQLite 数据库
- search - 搜索功能
- everart - 图像生成
- slack - Slack 集成
- sentry - 错误追踪

### hooks.json

Git 钩子配置：

- format-on-save - 保存文件后自动格式化
- lint-on-save - 保存文件后自动修复 ESLint 错误
- typecheck - 提交前检查类型
- test-before-commit - 提交前运行测试
