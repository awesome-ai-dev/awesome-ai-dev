# .cursor 目录索引

> AI 辅助开发配置合集

## 目录结构

```text
.cursor/
├── rules/          # 开发规范
│   ├── frontend/   # 前端规范
│   ├── backend/    # 后端规范
│   ├── devops/     # DevOps 规范
│   └── ai/         # AI 规范
├── skills/         # 技能
│   ├── frontend/   # 前端技能
│   ├── backend/    # 后端技能
│   ├── devops/     # DevOps 技能
│   └── ai/         # AI 技能
├── agents/         # 子代理
├── mcp.json        # MCP 配置
└── hooks.json      # 钩子配置
```

## Rules 索引

### 通用

| 文件 | 说明 |
|------|------|
| project.mdc | 通用项目规范 |

### 前端规范

| 文件 | 说明 |
|------|------|
| react.mdc | React 19 |
| vue3.mdc | Vue 3 |
| nextjs.mdc | Next.js |
| frontend/typescript.mdc | TypeScript |

### 后端规范

| 文件 | 说明 |
|------|------|
| nestjs.mdc | NestJS |
| python-fastapi.mdc | FastAPI |
| go.mdc | Go |
| mongodb.mdc | MongoDB |

### DevOps 规范

| 文件 | 说明 |
|------|------|
| dockerfile.mdc | Docker |
| kubernetes.mdc | Kubernetes |

### AI 规范

| 文件 | 说明 |
|------|------|
| python-data.mdc | Python 数据科学 |
| rust.mdc | Rust |

## Skills 索引

### 前端技能

| 技能 | 说明 |
|------|------|
| frontend/state | 状态管理 |
| frontend/ui | UI 组件库 |
| frontend/css | CSS 框架 |

### 后端技能

| 技能 | 说明 |
|------|------|
| backend/auth | 认证授权 |
| backend/orm | ORM 使用 |
| backend/cache | 缓存策略 |

### DevOps 技能

| 技能 | 说明 |
|------|------|
| devops/ci-cd | CI/CD 流水线 |
| devops/monitoring | 监控告警 |
| devops/infra | 基础设施 |

### AI 技能

| 技能 | 说明 |
|------|------|
| ai/llm | LLM 应用开发 |
| ai/rag | RAG 系统 |
| ai/agent | Agent 开发 |

### 专项技能

| 技能 | 说明 |
|------|------|
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
|-------|------|
| architect | 架构师 |
| fullstack-developer | 全栈开发 |
| backend-developer | 后端开发 |
| frontend-developer | 前端开发 |
| devops-engineer | DevOps 工程师 |
| data-engineer | 数据工程师 |
| security-expert | 安全专家 |
| test-engineer | 测试工程师 |
| code-reviewer | 代码审查员 |
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

---

## 配置文件说明

### mcp.json

MCP (Model Context Protocol) 服务器配置，支持多种工具集成。

### hooks.json

Git 钩子配置，支持提交前检查、代码格式化等。
