# .cursor 目录索引

> AI 辅助开发配置合集

## 目录结构

```
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
|-----|------|
| [project.mdc](rules/project.mdc) | 通用项目规范 |

### 前端
| 文件 | 说明 |
|-----|------|
| [react.mdc](rules/react.mdc) | React 19 |
| [vue3.mdc](rules/vue3.mdc) | Vue 3 |
| [nextjs.mdc](rules/nextjs.mdc) | Next.js |
| [frontend/typescript.mdc](rules/frontend/typescript.mdc) | TypeScript |

### 后端
| 文件 | 说明 |
|-----|------|
| [nestjs.mdc](rules/nestjs.mdc) | NestJS |
| [python-fastapi.mdc](rules/python-fastapi.mdc) | FastAPI |
| [go.mdc](rules/go.mdc) | Go |
| [mongodb.mdc](rules/mongodb.mdc) | MongoDB |

### DevOps
| 文件 | 说明 |
|-----|------|
| [dockerfile.mdc](rules/dockerfile.mdc) | Docker |
| [kubernetes.mdc](rules/kubernetes.mdc) | Kubernetes |

### AI
| 文件 | 说明 |
|-----|------|
| [python-data.mdc](rules/python-data.mdc) | Python 数据科学 |
| [rust.mdc](rules/rust.mdc) | Rust |

## Skills 索引

### 前端
| 技能 | 说明 |
|-----|------|
| [frontend/state](skills/frontend/state/) | 状态管理 |
| [frontend/ui](skills/frontend/ui/) | UI 组件库 |
| [frontend/css](skills/frontend/css/) | CSS 框架 |

### 后端
| 技能 | 说明 |
|-----|------|
| [backend/auth](skills/backend/auth/) | 认证授权 |
| [backend/orm](skills/backend/orm/) | ORM 使用 |
| [backend/cache](skills/backend/cache/) | 缓存策略 |

### DevOps
| 技能 | 说明 |
|-----|------|
| [devops/ci-cd](skills/devops/ci-cd/) | CI/CD 流水线 |
| [devops/monitoring](skills/devops/monitoring/) | 监控告警 |
| [devops/infra](skills/devops/infra/) | 基础设施 |

### AI
| 技能 | 说明 |
|-----|------|
| [ai/llm](skills/ai/llm/) | LLM 应用 |
| [ai/rag](skills/ai/rag/) | RAG 系统 |
| [ai/agent](skills/ai/agent/) | AI Agent |

---

## 快速使用

```markdown
# Rules
@react         # React 规范
@nestjs        # NestJS 规范
@python-fastapi # FastAPI 规范

# Skills
/skill frontend-state   # 状态管理
/skill backend-auth     # 认证授权
/skill ai-llm          # LLM 应用
```
