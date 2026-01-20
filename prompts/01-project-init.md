# 新建项目提示词

## 1. 全栈项目初始化

### 1.1 完整项目架构设计

```markdown
我要开发一个 [项目名称]，这是一个 [项目描述]。

技术栈要求：
- 前端：[Next.js/React/Vue 3]
- 后端：[NestJS/FastAPI/Express]
- 数据库：[PostgreSQL/MySQL/MongoDB]
- ORM：[Prisma/TypeORM/Drizzle]

请帮我设计：
1. 完整的数据库 Schema（使用 Prisma 格式），包含必要的索引和关联关系
2. RESTful API 接口列表，包含：
   - 接口路径和方法
   - 请求参数类型（TypeScript）
   - 响应数据类型（TypeScript）
   - 认证要求
3. 前端页面路由结构
4. 核心组件树设计
5. 状态管理方案

业务需求：
[详细描述你的业务需求]
```

### 1.2 快速原型（MVP）

```markdown
我需要快速搭建一个 [项目类型] 的 MVP 原型。

核心功能：
1. [功能1]
2. [功能2]
3. [功能3]

请使用以下技术栈帮我生成项目骨架：
- Next.js 14 (App Router)
- Tailwind CSS + Shadcn/ui
- Prisma + SQLite（本地开发）
- NextAuth.js（如需认证）

要求：
- 优先实现核心功能，忽略边缘情况
- 使用最简单的实现方式
- 代码可以后续重构，先跑起来
```

### 1.3 数据库设计专项

```markdown
请帮我设计一个 [业务场景] 的数据库模型。

业务实体：
- [实体1]：[描述]
- [实体2]：[描述]
- [实体3]：[描述]

关系说明：
- [实体1] 和 [实体2] 是 [一对多/多对多] 关系
- ...

要求：
1. 使用 Prisma Schema 格式
2. 添加适当的索引优化查询性能
3. 包含 createdAt/updatedAt/deletedAt 字段
4. 考虑软删除场景
5. 添加必要的枚举类型

预期数据量：[大概的数据规模]
```

---

## 2. 前端项目初始化

### 2.1 Next.js 项目

```markdown
创建一个 Next.js 14 项目，要求：

项目类型：[官网/后台管理/电商/博客/SaaS]

技术配置：
- TypeScript 严格模式
- Tailwind CSS
- 组件库：Shadcn/ui
- 状态管理：Zustand
- 数据请求：TanStack Query
- 表单处理：React Hook Form + Zod

请生成：
1. 推荐的目录结构
2. 必要的配置文件（next.config.js, tailwind.config.js, tsconfig.json）
3. 基础布局组件
4. API 客户端封装
5. 通用工具函数
```

### 2.2 React + Vite 项目

```markdown
创建一个 React + Vite 项目，要求：

项目类型：[SPA 应用/组件库/Chrome 插件]

技术配置：
- TypeScript
- Tailwind CSS
- 路由：React Router v6
- 状态管理：Zustand
- 请求：Axios + TanStack Query

请生成：
1. 项目目录结构
2. Vite 配置（路径别名、代理等）
3. 路由配置模板
4. API 请求封装
5. 基础布局组件
```

### 2.3 Vue 3 项目

```markdown
创建一个 Vue 3 项目，要求：

项目类型：[后台管理系统/移动端 H5/官网]

技术配置：
- Vite
- TypeScript
- Tailwind CSS / UnoCSS
- 状态管理：Pinia
- 路由：Vue Router 4
- 组件库：[Element Plus/Naive UI/Ant Design Vue]

请生成：
1. 项目目录结构
2. Vite 配置
3. 路由配置（含守卫）
4. Pinia Store 模板
5. API 请求封装
6. 基础布局组件
```

---

## 3. 后端项目初始化

### 3.1 NestJS 项目

```markdown
创建一个 NestJS 后端项目，要求：

项目类型：[RESTful API/GraphQL/微服务]

功能模块：
1. 用户认证（JWT）
2. [业务模块1]
3. [业务模块2]

技术配置：
- Prisma ORM
- PostgreSQL
- Redis（缓存/队列）
- Swagger 文档
- Docker 部署

请生成：
1. 项目目录结构
2. 通用模块（异常过滤器、响应拦截器、验证管道）
3. 认证模块完整代码
4. 示例业务模块 CRUD
5. Prisma Schema
6. Docker Compose 配置
```

### 3.2 FastAPI 项目

```markdown
创建一个 FastAPI 后端项目，要求：

项目类型：[RESTful API/AI 服务/数据处理]

功能模块：
1. [模块1]
2. [模块2]

技术配置：
- SQLAlchemy 2.0 (async)
- PostgreSQL
- Pydantic v2
- Alembic 迁移
- Redis

请生成：
1. 项目目录结构
2. 数据库连接和会话管理
3. Pydantic Schema 模板
4. 通用异常处理
5. 认证中间件
6. 示例 CRUD 路由
```

---

## 4. 特定场景初始化

### 4.1 AI/LLM 应用

```markdown
我要开发一个 AI 对话应用，要求：

功能：
- 多轮对话
- 流式输出
- 对话历史保存
- 多模型切换

技术栈：
- 前端：Next.js + Vercel AI SDK
- 后端：[FastAPI/Next.js API Routes]
- LLM：[OpenAI/Claude/本地模型]

请帮我设计：
1. 前端对话组件结构
2. 流式响应处理逻辑
3. 后端 API 设计
4. 消息存储 Schema
5. Token 计费逻辑（如需要）
```

### 4.2 后台管理系统

```markdown
我要开发一个后台管理系统，包含以下功能：

核心功能：
- 用户管理（CRUD、角色分配）
- 权限管理（RBAC）
- 菜单管理
- 操作日志
- [其他业务模块]

技术栈：
- 前端：[Next.js/Vue 3] + [Shadcn/Element Plus]
- 后端：[NestJS/FastAPI]
- 数据库：PostgreSQL

请帮我设计：
1. 完整的数据库 Schema（用户、角色、权限、菜单）
2. 权限控制流程
3. 前端路由结构（含权限过滤）
4. 通用列表/表单页面模板
```

### 4.3 电商系统

```markdown
我要开发一个电商系统，包含以下功能：

用户端：
- 商品浏览、搜索
- 购物车
- 订单管理
- 支付集成

商家端：
- 商品管理
- 订单处理
- 数据统计

请帮我设计：
1. 完整的数据库 Schema（商品、SKU、订单、支付等）
2. 核心业务流程（下单、支付、发货）
3. API 接口设计
4. 前端页面结构
5. 库存扣减方案（并发安全）
```

---

## 5. 组件/功能模块初始化

### 5.1 通用 CRUD 模块

```markdown
请为 [模块名称] 生成完整的 CRUD 代码：

数据模型：
[粘贴你的 Prisma/SQLAlchemy 模型]

要求：
- 后端：[NestJS/FastAPI] 
  - Controller/Router
  - Service
  - DTOs/Schemas
  - 分页查询
  - 搜索过滤
  
- 前端：[React/Vue]
  - 列表页（表格、分页、搜索、批量操作）
  - 新增/编辑表单（抽屉/弹窗）
  - 删除确认
  
请确保：
- 完整的类型定义
- 错误处理
- Loading 状态
- 表单验证
```

### 5.2 认证模块

```markdown
请为我的 [NestJS/FastAPI/Next.js] 项目生成完整的认证模块：

功能要求：
- 注册（邮箱验证可选）
- 登录（JWT）
- 刷新 Token
- 登出
- 密码重置
- OAuth 登录（[Google/GitHub/微信]）

请生成：
1. 数据库 Schema（用户表）
2. API 接口完整代码
3. 中间件/守卫
4. 前端登录/注册表单
5. Token 存储和刷新逻辑
```
