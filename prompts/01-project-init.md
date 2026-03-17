# 项目初始化提示词

## 需求分析模板

```markdown
请帮我分析以下需求：

项目名称：[名称]
核心功能：[功能描述]
目标用户：[用户群体]
技术要求：[技术栈要求]

请给出：
1. 技术选型建议
2. 项目结构
3. 核心功能拆分
```

## 技术选型因素

| 类型 | 考虑因素 |
|-----|---------|
| 前端 | 团队技术栈 / SEO / 性能 / SSR 需求 |
| 后端 | 并发量 / 数据规模 / 实时性 / 运维成本 |
| 数据库 | 数据类型 / 事务需求 / 扩展性 |

## 初始化命令

### Next.js 15
```bash
npx create-next-app@latest my-app --typescript --tailwind --app --eslint
```

### Vue 3.5
```bash
npm create vue@latest my-app --typescript --pinia
```

### NestJS 11
```bash
npm i -g @nestjs/cli
nest new my-app --package-manager npm
```

### FastAPI
```bash
pip install fastapi uvicorn
```

---
