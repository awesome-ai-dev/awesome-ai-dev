# AI 驱动的全栈开发方法论

> 针对 React/Vue/Next.js 前端 + NestJS/Express/Python 后端的 AI 辅助开发指南

---

## 目录

1. [核心理念](#核心理念)
2. [新应用开发](#新应用开发)
3. [老项目重构](#老项目重构)
4. [经验沉淀与复用](#经验沉淀与复用)
5. [AI 友好的技术栈选择](#ai-友好的技术栈选择)
6. [常见陷阱与规避策略](#常见陷阱与规避策略)
7. [Prompt 指令库](#prompt-指令库)

---

## 核心理念

在 AI 时代，开发者的角色正在从 **"代码搬运工"** 转变为 **"架构师"** 和 **"代码审查者"**。

### 三个关键转变

| 传统开发 | AI 辅助开发 |
|---------|------------|
| 记忆 API 和语法 | 理解架构和业务逻辑 |
| 手写重复代码 | 审查 AI 生成的代码 |
| 在 StackOverflow 搜索 | 精准描述问题上下文 |

### 黄金法则

```
你的竞争力 = 规范化能力 × 上下文管理能力 × 审查能力
```

---

## 新应用开发

### 阶段一：架构设计优先 (Architect First)

**不要直接写代码。** 先用 AI 生成架构文档。

#### 推荐流程

```
1. 业务需求 → 2. 数据模型 → 3. API 契约 → 4. 组件树 → 5. 代码实现
```

#### Prompt 示例

```markdown
我要开发一个 [项目描述]，请帮我设计：
1. 数据库 Schema（使用 Prisma 格式）
2. RESTful API 接口列表（包含请求/响应类型）
3. 前端页面路由和组件树结构
```

### 阶段二：上下文管理

#### 使用 `.cursorrules` 文件

在项目根目录创建 `.cursorrules`，定义代码偏好：

```markdown
# 项目规范

## 代码风格
- 使用函数式组件，禁止 Class Component
- 优先使用 TypeScript 严格模式
- 使用 pnpm 作为包管理器

## 前端规范
- 状态管理：小项目用 Zustand，大项目用 Redux Toolkit
- 数据请求：使用 TanStack Query，禁止在 useEffect 中直接 fetch
- 表单验证：统一使用 Zod + React Hook Form

## 后端规范
- 接口返回格式：{ code: number, data: T, message: string }
- 错误处理：使用统一的异常过滤器
- 数据校验：NestJS 使用 class-validator，Python 使用 Pydantic
```

#### 模块化对话

每次只让 AI 专注一个 Feature：

```markdown
✅ 好的做法：
"根据 @prisma/schema.prisma 中的 User 模型，生成 NestJS 的 CRUD 模块"

❌ 坏的做法：
"帮我写一个完整的用户系统，包含登录注册、权限管理、个人中心..."
```

### 阶段三：快速原型

#### 前端原型（Next.js + Shadcn）

```bash
# 快速初始化
pnpm create next-app@latest my-app --typescript --tailwind --eslint --app
cd my-app
pnpm dlx shadcn@latest init
```

#### 后端原型（NestJS）

```bash
# 快速初始化
nest new my-api
cd my-api
pnpm add @prisma/client
pnpm add -D prisma
npx prisma init
```

---

## 老项目重构

老项目重构最怕的是 **破坏原有逻辑**。AI 在这里扮演的是 **"翻译官"** 和 **"安全员"** 的角色。

### 策略一：逆向文档化

在动手之前，先让 AI 理解现有代码：

```markdown
请分析这段代码的逻辑，并列出：
1. 主要功能和数据流
2. 所有的边界条件和异常处理
3. 隐含的业务规则
4. 潜在的 Bug 或技术债
```

### 策略二：渐进式迁移 (Strangler Fig Pattern)

不要一次性重写，而是逐步替换：

#### JavaScript → TypeScript

```markdown
Prompt: 将以下 JS 代码转换为 TypeScript，补充完整的类型定义：
- 为所有函数参数和返回值添加类型
- 为对象创建 Interface
- 处理可能的 null/undefined
```

#### Class Component → Hooks

```markdown
Prompt: 将这个 React Class Component 重构为函数式组件：
- 使用 useState 替代 this.state
- 使用 useEffect 替代生命周期方法
- 保持完全相同的功能和行为
```

#### Vue 2 Options API → Vue 3 Composition API

```markdown
Prompt: 将这个 Vue 2 组件迁移到 Vue 3 Composition API：
- 使用 <script setup> 语法
- 使用 ref/reactive 替代 data
- 使用 computed 和 watch
```

### 策略三：测试先行

在重构前，先用 AI 生成测试：

```markdown
Prompt: 根据这段代码的功能，生成完整的单元测试：
- 使用 Vitest/Jest
- 覆盖正常情况和边界条件
- 包含异常处理测试
```

这样重构后，只要测试通过，就能确保功能不变。

---

## 经验沉淀与复用

**这是最关键的一点：不要让你的 AI 调试经验随项目结束而消失。**

### 方法一：建立指令库 (Prompt Snippets)

总结那些"一次性解决复杂问题"的高质量 Prompt：

```markdown
## 我的 Prompt 库

### 流式响应处理
"将这段 Python 处理逻辑重构为流式响应，以支持大模型的 SSE 输出，
使用 async generator 和 StreamingResponse"

### React 表单完整状态
"为这个 React 表单添加：
1. 基于 Zod 的验证 Schema
2. Loading 状态处理
3. Error 状态显示
4. 成功后的 Toast 提示
5. 乐观更新（如适用）"

### 数据库查询优化
"分析这段 Prisma 查询的性能问题，并优化：
1. 避免 N+1 查询
2. 只 select 需要的字段
3. 添加适当的索引建议"
```

### 方法二：维护 `.cursorrules` 模版

将你的规则分为三类：

```markdown
## 代码风格规则
- Always use `pnpm` as package manager
- No default exports, use named exports
- Use absolute imports with @ alias

## 性能规范
- Use `useCallback` for functions passed to memoized components
- Use `useMemo` for expensive calculations
- Implement virtual scrolling for lists > 100 items

## AI 避坑规则（AI 经常犯的错误）
- ❌ 不要在 useEffect 依赖数组中遗漏依赖
- ❌ 不要在 NestJS 中忘记添加 @Injectable() 装饰器
- ❌ 不要在 async 函数中忘记错误处理
- ❌ 不要生成 any 类型，必须定义具体类型
```

### 方法三：文档即上下文 (Docs as Context)

在新项目中引用老项目的规范：

```markdown
# 在 Cursor 中使用
@BestPractices.md 参考这个文档的风格，为用户模块生成代码
@api-conventions.md 按照这个 API 规范设计接口
```

### 方法四：建立 "Shadow 项目"

维护一个个人的"终极全栈模版"：

```
my-ultimate-template/
├── frontend/
│   ├── next.config.js          # 优化过的配置
│   ├── src/
│   │   ├── lib/api-client.ts   # 封装好的请求库
│   │   ├── hooks/              # 常用自定义 Hooks
│   │   └── components/ui/      # 基础组件库
│   └── .cursorrules
├── backend/
│   ├── src/
│   │   ├── common/             # 通用模块（异常、拦截器）
│   │   ├── auth/               # 认证模块
│   │   └── prisma/             # 数据库配置
│   └── .cursorrules
└── docs/
    ├── API_CONVENTIONS.md
    ├── BEST_PRACTICES.md
    └── PROMPT_LIBRARY.md
```

---

## AI 友好的技术栈选择

AI 在以下技术栈上表现最稳定（训练数据最丰富）：

### 前端推荐

| 类别 | 推荐 | 理由 |
|-----|------|-----|
| 框架 | Next.js (App Router) | 文档完善，AI 理解深刻 |
| 样式 | Tailwind CSS | 类名语义化，AI 生成准确 |
| 组件库 | Shadcn/ui | 源码透明，可定制性强 |
| 状态管理 | Zustand / Jotai | API 简洁，AI 不易出错 |
| 数据请求 | TanStack Query | 模式固定，AI 熟练掌握 |
| 表单验证 | Zod + React Hook Form | 类型安全，AI 生成质量高 |

### 后端推荐

| 类别 | 推荐 | 理由 |
|-----|------|-----|
| Node.js | NestJS | 强类型 + 装饰器，结构清晰 |
| Python | FastAPI | 类型提示 + 自动文档，AI 友好 |
| ORM | Prisma | Schema 即文档，AI 理解准确 |
| 验证 | class-validator / Pydantic | 声明式验证，生成质量高 |

### 工具链推荐

| 类别 | 推荐 | 理由 |
|-----|------|-----|
| Linter | Biome | 比 ESLint 快，配置简单 |
| 测试 | Vitest | 兼容 Jest API，更快更现代 |
| 包管理 | pnpm | 速度快，磁盘占用小 |

---

## 常见陷阱与规避策略

### 陷阱 1：过度依赖 AI 生成

```markdown
❌ 问题：直接使用 AI 生成的代码，不审查
✅ 解决：建立 Code Review 清单

- [ ] 类型是否完整（无 any）
- [ ] 错误处理是否充分
- [ ] 是否有安全漏洞（SQL 注入、XSS）
- [ ] 性能是否合理（无 N+1 查询）
- [ ] 是否符合项目规范
```

### 陷阱 2：上下文丢失

```markdown
❌ 问题：AI 在长对话中忘记之前的约定
✅ 解决：
1. 使用 .cursorrules 固化规范
2. 在关键对话中重复核心约束
3. 将大任务拆分为小任务
```

### 陷阱 3：AI 幻觉（编造 API）

```markdown
❌ 问题：AI 生成不存在的库方法
✅ 解决：
1. 要求 AI 只使用你指定版本的 API
2. 对于不确定的代码，先让 AI 解释原理
3. 生成后立即运行验证
```

### 陷阱 4：重复造轮子

```markdown
❌ 问题：每个项目都从零开始
✅ 解决：
1. 维护个人模版库
2. 总结可复用的代码片段
3. 建立标准化的项目结构
```

---

## Prompt 指令库

### 架构设计类

```markdown
## 生成数据模型
请根据以下业务需求，设计 Prisma Schema：
[需求描述]
要求：
1. 合理的表关系设计
2. 添加必要的索引
3. 包含 createdAt/updatedAt 字段

## 生成 API 设计
为 [模块名] 设计 RESTful API：
1. 列出所有端点（GET/POST/PUT/DELETE）
2. 定义请求和响应的 TypeScript 类型
3. 包含分页、筛选、排序参数
```

### 代码生成类

```markdown
## NestJS CRUD 模块
根据 @prisma/schema.prisma 中的 [Model] 模型，生成完整的 NestJS 模块：
1. Controller（包含 Swagger 文档）
2. Service（包含事务处理）
3. DTOs（包含验证规则）
4. 单元测试

## React 页面组件
创建一个 [功能描述] 页面：
1. 使用 Server Components 优先
2. 数据获取使用 TanStack Query
3. 表单使用 React Hook Form + Zod
4. 样式使用 Tailwind CSS
5. 包含 Loading 和 Error 状态
```

### 重构优化类

```markdown
## 性能优化
分析以下代码的性能问题并优化：
[代码]
重点关注：
1. 不必要的重渲染
2. 内存泄漏
3. 重复计算

## 代码重构
将以下代码重构为更清晰的结构：
[代码]
要求：
1. 保持功能不变
2. 提高可读性
3. 添加类型定义
4. 提取可复用逻辑
```

### Debug 类

```markdown
## 错误分析
我遇到了以下错误：
[错误信息]
相关代码：
[代码]
请分析：
1. 错误的根本原因
2. 解决方案
3. 如何避免类似错误
```

---

## 总结

```
┌─────────────────────────────────────────────────────────┐
│                AI 辅助开发成功公式                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   成功 = 清晰的架构 + 规范化的上下文 + 持续的经验沉淀      │
│                                                         │
│   • 架构：先设计，后编码                                  │
│   • 上下文：用 .cursorrules 和文档固化规范                │
│   • 沉淀：建立 Prompt 库和模版项目                        │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**记住：AI 是你的副驾驶，但方向盘始终在你手中。**

---

*最后更新：2026-01-20*
