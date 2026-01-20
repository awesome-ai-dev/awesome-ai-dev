# 代码生成提示词

## 1. 功能模块生成

### 1.1 CRUD 完整模块

```markdown
请为 [模块名称] 生成完整的 CRUD 代码：

数据模型：
```prisma
model [ModelName] {
  id        String   @id @default(cuid())
  [field1]  [Type]
  [field2]  [Type]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

后端技术栈：[NestJS/FastAPI/Express]
前端技术栈：[React/Vue/Next.js]

后端需要生成：
- Controller/Router（含 Swagger 文档）
- Service（含事务处理）
- DTOs/Schemas（含验证）
- 单元测试

前端需要生成：
- 列表页（表格、分页、搜索、筛选）
- 新增/编辑表单（Modal 或独立页面）
- 删除确认
- API 请求 hooks/函数
- TypeScript 类型定义

确保代码遵循以下规范：
[粘贴你的 .cursorrules 或描述规范]
```

### 1.2 认证模块

```markdown
请生成完整的用户认证模块：

技术栈：
- 后端：[NestJS/FastAPI/Next.js API Routes]
- 前端：[React/Vue/Next.js]
- 认证方式：[JWT/Session/NextAuth]

功能需求：
- [x] 用户注册（邮箱/手机号）
- [x] 用户登录
- [x] Token 刷新
- [x] 退出登录
- [ ] 邮箱验证
- [ ] 手机号验证
- [ ] 忘记密码
- [ ] OAuth 登录（Google/GitHub/微信）

请生成：
1. 数据库 Schema（用户表）
2. 后端 API 完整代码
3. 认证中间件/守卫
4. 前端登录/注册页面
5. Token 管理逻辑
6. 路由保护实现
```

### 1.3 文件上传模块

```markdown
请生成文件上传功能：

技术栈：
- 后端：[NestJS/FastAPI/Express]
- 存储：[本地/S3/OSS/七牛]
- 前端：[React/Vue]

功能需求：
- 单文件上传
- 多文件上传
- 拖拽上传
- 上传进度显示
- 文件类型限制：[图片/文档/视频]
- 文件大小限制：[XX MB]
- 图片预览
- 分片上传（大文件）

请生成：
1. 后端上传接口
2. 文件存储配置
3. 前端上传组件
4. 进度条组件
5. 预览组件
```

---

## 2. 数据处理

### 2.1 数据转换函数

```markdown
请为我生成数据转换函数：

输入数据格式：
```typescript
type Input = {
  [描述输入数据结构]
}
```

输出数据格式：
```typescript
type Output = {
  [描述输出数据结构]
}
```

转换规则：
1. [规则1]
2. [规则2]
3. [规则3]

要求：
- 使用 TypeScript
- 处理边界情况（null/undefined/空数组）
- 包含单元测试
```

### 2.2 数据验证 Schema

```markdown
请为以下数据生成 Zod/Yup 验证 Schema：

数据字段：
| 字段名 | 类型 | 必填 | 验证规则 |
|--------|------|------|----------|
| name | string | 是 | 2-50字符 |
| email | string | 是 | 邮箱格式 |
| age | number | 否 | 1-120 |
| ...

请生成：
1. Zod Schema 定义
2. TypeScript 类型（使用 z.infer）
3. 自定义错误消息（中文）
4. 使用示例
```

### 2.3 API 响应处理

```markdown
请为以下 API 响应生成处理函数：

API 响应格式：
```json
{
  "code": 200,
  "data": { ... },
  "message": "success"
}
```

需要处理的场景：
1. 成功响应 - 提取 data
2. 业务错误 - 显示 message
3. 网络错误 - 显示通用错误
4. 401 错误 - 跳转登录
5. 数据转换 - [描述转换规则]

技术栈：[Axios/Fetch] + [React/Vue]

请生成：
1. 请求拦截器
2. 响应拦截器
3. 错误处理函数
4. TypeScript 类型定义
```

---

## 3. 组件生成

### 3.1 表单组件

```markdown
请生成一个 [表单名称] 表单组件：

字段列表：
| 字段名 | 标签 | 类型 | 验证规则 |
|--------|------|------|----------|
| username | 用户名 | 文本 | 必填，3-20字符 |
| email | 邮箱 | 邮箱 | 必填，邮箱格式 |
| password | 密码 | 密码 | 必填，6-20字符 |
| role | 角色 | 选择框 | 必填，选项：admin/user |
| avatar | 头像 | 图片上传 | 可选 |

技术栈：
- [React Hook Form + Zod / VeeValidate + Zod]
- [Tailwind CSS / Shadcn]
- TypeScript

功能要求：
- 实时验证
- 提交 Loading 状态
- 表单重置
- 编辑模式（回填数据）

请生成完整的表单组件代码。
```

### 3.2 列表组件

```markdown
请生成一个 [列表名称] 列表组件：

数据类型：
```typescript
interface Item {
  [定义数据字段]
}
```

功能要求：
- 表格展示 / 卡片展示
- 分页（每页 10 条）
- 搜索（按 [字段] 搜索）
- 筛选（按 [字段] 筛选）
- 排序（按 [字段] 排序）
- 批量选择
- 行操作（编辑/删除/[其他]）

技术栈：
- [TanStack Table + React / Vue]
- [Tailwind CSS / Element Plus / Ant Design]
- TypeScript

请生成完整的列表组件代码，包含：
1. 列表组件
2. 搜索筛选组件
3. 分页组件
4. 操作按钮组件
5. API 调用 hooks
```

### 3.3 模态框/抽屉组件

```markdown
请生成一个 [用途描述] 的 [Modal/Drawer] 组件：

触发方式：[按钮点击/编辑操作/其他]

内容：
- [描述模态框内容，如表单/详情/确认]

功能要求：
- 打开/关闭动画
- 点击遮罩关闭（可配置）
- ESC 键关闭
- 确认/取消按钮
- Loading 状态
- 阻止背景滚动

技术栈：
- [React + Radix Dialog / Vue + Element Plus]
- Tailwind CSS

请生成完整的组件代码和使用示例。
```

---

## 4. 工具函数

### 4.1 常用工具函数集

```markdown
请生成以下工具函数：

1. 防抖函数 (debounce)
2. 节流函数 (throttle)
3. 深拷贝函数 (deepClone)
4. 日期格式化 (formatDate)
5. 数字格式化 (formatNumber)
6. 文件大小格式化 (formatFileSize)
7. URL 参数解析 (parseQuery)
8. 随机字符串生成 (randomString)
9. 数组去重 (unique)
10. 树形数据处理 (flattenTree, buildTree)

要求：
- TypeScript 类型完整
- 处理边界情况
- 包含 JSDoc 注释
- 包含使用示例
```

### 4.2 特定工具函数

```markdown
请生成一个 [功能描述] 的工具函数：

输入：
- 参数1：[类型] - [说明]
- 参数2：[类型] - [说明]

输出：
- [类型] - [说明]

示例：
```typescript
// 输入
const input = [示例输入]

// 期望输出
const output = [期望输出]
```

边界情况：
1. [边界情况1]
2. [边界情况2]

请生成：
1. 函数实现
2. 类型定义
3. 单元测试
```

---

## 5. API 相关

### 5.1 API 客户端

```markdown
请生成一个封装好的 API 客户端：

基础配置：
- 基础 URL：从环境变量读取
- 超时时间：30 秒
- 认证方式：Bearer Token

拦截器需求：
- 请求拦截：自动添加 Token
- 响应拦截：统一处理响应格式
- 错误处理：401 跳转登录，其他显示错误

技术栈：[Axios/Fetch] + TypeScript

请生成：
1. API 客户端配置
2. 请求/响应拦截器
3. 通用请求方法 (get/post/put/delete)
4. 类型定义
5. 使用示例
```

### 5.2 API Hooks 生成

```markdown
请为以下 API 生成 React/Vue Hooks：

API 列表：
| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 获取列表 | GET | /api/users | 支持分页和搜索 |
| 获取详情 | GET | /api/users/:id | - |
| 创建 | POST | /api/users | - |
| 更新 | PUT | /api/users/:id | - |
| 删除 | DELETE | /api/users/:id | - |

技术栈：
- [TanStack Query / SWR / VueQuery]
- TypeScript

请生成：
1. API 函数
2. Query Hooks（查询）
3. Mutation Hooks（变更）
4. 类型定义
5. 使用示例
```

---

## 6. 测试代码

### 6.1 单元测试

```markdown
请为以下代码生成单元测试：

代码：
```[typescript/javascript]
[粘贴需要测试的代码]
```

测试框架：[Vitest/Jest]

测试要求：
- 覆盖正常情况
- 覆盖边界情况
- 覆盖异常情况
- 覆盖率目标：80%+

请生成完整的测试文件。
```

### 6.2 组件测试

```markdown
请为以下 React/Vue 组件生成测试：

组件代码：
```[tsx/vue]
[粘贴组件代码]
```

测试框架：
- [Testing Library + Vitest/Jest]
- [Vue Test Utils]

测试场景：
1. 正常渲染
2. Props 变化
3. 用户交互（点击、输入等）
4. 异步操作
5. 错误状态

请生成完整的测试文件。
```

### 6.3 E2E 测试

```markdown
请为以下用户流程生成 E2E 测试：

用户流程：
1. [步骤1]
2. [步骤2]
3. [步骤3]
4. [期望结果]

测试框架：[Playwright/Cypress]

页面信息：
- 登录页：/login
- 列表页：/users
- 详情页：/users/:id

请生成完整的 E2E 测试脚本。
```

---

## 7. 配置文件

### 7.1 项目配置

```markdown
请生成以下配置文件：

项目类型：[Next.js/Vite+React/Vite+Vue]

需要的配置：
- [ ] TypeScript (tsconfig.json)
- [ ] ESLint (.eslintrc.js)
- [ ] Prettier (.prettierrc)
- [ ] Tailwind (tailwind.config.js)
- [ ] 环境变量 (.env.example)
- [ ] Git hooks (husky + lint-staged)
- [ ] VS Code 配置 (.vscode/settings.json)

特殊要求：
- 路径别名：@ -> src/
- 严格的 TypeScript 配置
- 统一的代码风格
```

### 7.2 Docker 配置

```markdown
请为我的 [项目类型] 项目生成 Docker 配置：

项目结构：
- frontend/（[Next.js/Vite]）
- backend/（[NestJS/FastAPI]）
- 数据库：[PostgreSQL/MySQL]
- 缓存：[Redis]（可选）

需要生成：
1. frontend/Dockerfile
2. backend/Dockerfile
3. docker-compose.yml（开发环境）
4. docker-compose.prod.yml（生产环境）
5. .dockerignore

要求：
- 多阶段构建优化镜像大小
- 热重载支持（开发环境）
- 环境变量配置
- 网络和卷配置
```

### 7.3 CI/CD 配置

```markdown
请生成 [GitHub Actions/GitLab CI] 配置：

项目类型：[Next.js/NestJS/Monorepo]

需要的流程：
1. 代码检查（lint）
2. 类型检查（tsc）
3. 单元测试
4. 构建
5. 部署到 [Vercel/AWS/自有服务器]

分支策略：
- main：生产环境
- develop：测试环境
- feature/*：PR 检查

请生成完整的 CI/CD 配置文件。
```
