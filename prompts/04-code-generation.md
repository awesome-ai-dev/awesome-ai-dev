# 代码生成提示词

## 完整功能生成

```markdown
请帮我生成 [功能名称] 功能代码：

## 功能需求
[描述功能需求]

## 技术栈
- 框架：[Next.js 15 / Vue 3.5 / NestJS 11]
- 状态管理：[Zustand / Pinia / Context]
- 数据库：[PostgreSQL / MySQL]

## 要求
1. 遵循项目规范
2. 包含错误处理
3. 类型安全
```

## CRUD 生成

```markdown
生成 User 的完整 CRUD：
- 字段：id, name, email, role, createdAt
- API：/api/users (RESTful)
- 操作：列表 / 详情 / 创建 / 更新 / 删除
```

## React 19 特性使用

```markdown
请使用 React 19 新特性生成代码：
- Server Actions 处理表单
- use() 简化数据获取
- useOptimistic 实现乐观更新
```

## 组件生成

```markdown
生成 [组件名] 组件：
- 用途：[描述]
- Props：TypeScript 接口
- 交互：事件处理
- 样式：Tailwind CSS
```

## 注意事项

1. 先生成类型定义
2. 再生成业务逻辑
3. 最后生成 UI
4. 确保类型安全

---
