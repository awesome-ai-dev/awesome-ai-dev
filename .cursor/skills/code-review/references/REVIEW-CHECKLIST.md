# 代码审查清单

## 1. 代码质量

### 1.1 可读性

- [ ] 变量/函数命名清晰表达意图
- [ ] 函数长度合理（建议 < 50 行）
- [ ] 避免深层嵌套（建议 < 3 层）
- [ ] 有适当的注释解释复杂逻辑

### 1.2 可维护性

- [ ] 代码重复最小化
- [ ] 单一职责原则
- [ ] 模块化设计
- [ ] 依赖关系清晰

### 1.3 复杂性

- [ ] 圈复杂度 < 10
- [ ] 函数参数 < 4 个
- [ ] 没有过长的文件（< 300 行）

---

## 2. 功能正确性

### 2.1 业务逻辑

- [ ] 实现符合需求
- [ ] 边界条件处理
- [ ] 错误处理完善
- [ ] 日志记录适当

### 2.2 数据处理

- [ ] 输入验证
- [ ] 数据类型正确
- [ ] 序列化/反序列化正确
- [ ] 敏感数据处理

---

## 3. 安全性

### 3.1 常见漏洞

- [ ] 无 SQL 注入风险
- [ ] 无 XSS 风险
- [ ] 无 CSRF 风险
- [ ] 敏感信息不泄露

### 3.2 认证授权

- [ ] 身份验证正确
- [ ] 权限检查完整
- [ ] Session 管理安全

### 3.3 加密

- [ ] 密码哈希存储
- [ ] 敏感数据加密
- [ ] 安全传输（HTTPS）

---

## 4. 性能

### 4.1 数据库

- [ ] 无 N+1 查询
- [ ] 适当索引
- [ ] 查询优化

### 4.2 内存

- [ ] 无内存泄漏
- [ ] 资源正确释放
- [ ] 大数据流式处理

### 4.3 前端

- [ ] 无不必要重渲染
- [ ] 懒加载适当
- [ ] 缓存策略合理

---

## 5. 测试

### 5.1 单元测试

- [ ] 核心逻辑有测试
- [ ] 测试覆盖关键路径
- [ ] Mock 使用适当

### 5.2 测试质量

- [ ] 测试命名清晰
- [ ] AAA 模式
- [ ] 断言有意义

---

## 6. 代码规范

### 6.1 格式

- [ ] 缩进一致
- [ ] 空格适当
- [ ] 换行合理

### 6.2 命名

- [ ] 遵循语言惯例
- [ ] 命名一致
- [ ] 无缩写误导

### 6.3 TypeScript

- [ ] 类型完整
- [ ] 无 any
- [ ] 泛型使用适当

---

## 7. 最佳实践

### 7.1 错误处理

```typescript
// ✅ 好的错误处理
try {
  await riskyOperation();
} catch (error) {
  logger.error('Operation failed', { error, context });
  throw new AppError('Operation failed', ErrorCode.INTERNAL);
}

// ❌ 不好
try {
  await riskyOperation();
} catch (e) {
  console.log(e);
}
```

### 7.2 验证

```typescript
// ✅ 输入验证
const schema = z.object({
  email: z.string().email(),
  age: z.number().min(0),
});

const data = schema.parse(req.body);

// ❌ 无验证
const { email, age } = req.body;
```

### 7.3 异步

```typescript
// ✅ 正确处理异步
async function fetchData() {
  try {
    const data = await api.getData();
    return data;
  } catch (error) {
    logger.error('Fetch failed', { error });
    throw error;
  }
}

// ❌ 未处理 promise
api.getData(); // 没有 await
```

---

## 8. 审查反馈格式

```markdown
## 审查结果

### 问题

| 严重程度 | 位置 | 问题 | 建议 |
 |---:| --- |---:| --- |
| 🔴 高 | file.ts:20 | SQL 注入风险 | 使用参数化查询 |
| 🟡 中 | component.tsx:45 | 重复代码 | 提取为 hooks |
| 🟢 低 | utils.ts:10 | 命名可优化 | 更清晰的命名 |

### 优点
- 代码结构清晰
- 错误处理完善

### 总体评价
[评价]
```
