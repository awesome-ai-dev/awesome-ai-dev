# 数据库查询优化指南

## 1. N+1 问题

### 什么是 N+1 问题

N+1 查询是指在查询数据时，先执行 1 次查询获取主数据，然后对每条数据执行 N 次查询获取关联数据。

### 典型案例

```typescript
// ❌ N+1 查询
const users = await prisma.user.findMany();
for (const user of users) {
  const posts = await prisma.post.findMany({
    where: { authorId: user.id }
  });
}

// ✅ 使用 include 解决
const users = await prisma.user.findMany({
  include: { posts: true }
});
```

### 解决方案

| 方法 | 适用场景 | 示例 |
| --- | --- | --- |
| include | 一对多、多对多 | `include: { posts: true }` |
| select | 只取关联字段 | `select: { posts: { select: { title: true } } }` |
| join (Raw SQL) | 复杂查询 | `prisma.$queryRaw` |

## 2. 索引优化

### 何时创建索引

- WHERE 子句中经常使用的列
- ORDER BY 中使用的列
- 外键列
- 高选择性的列

### 索引类型选择

```sql
-- 单列索引
CREATE INDEX idx_user_email ON users(email);

-- 复合索引（注意列顺序）
CREATE INDEX idx_order_status_created ON orders(status, created_at);

-- 部分索引
CREATE INDEX idx_active_users ON users(email) WHERE status = 'active';

-- 唯一索引
CREATE UNIQUE INDEX idx_user_email ON users(email);
```

### 索引失效情况

- 使用函数/表达式：`WHERE LOWER(email) = 'xxx'`
- 类型转换：`WHERE id = '1'` (id 是整数)
- 前缀通配符：`WHERE email LIKE '%@gmail.com'`

## 3. 查询优化技巧

### 分页优化

```sql
-- ❌ 慢：OFFSET 大时性能下降
SELECT * FROM orders ORDER BY id LIMIT 10 OFFSET 100000;

-- ✅ 游标分页
SELECT * FROM orders WHERE id < 100010 ORDER BY id LIMIT 10;
```

### 批量操作

```typescript
// ❌ 循环插入
for (const item of items) {
  await prisma.order.create({ data: item });
}

// ✅ 批量插入
await prisma.order.createMany({ data: items });
```

### 选择必要字段

```typescript
// ❌ 取所有字段
const users = await prisma.user.findMany();

// ✅ 只取需要的字段
const users = await prisma.user.findMany({
  select: { id: true, name: true, email: true }
});
```

## 4. 监控与诊断

### 使用 EXPLAIN 分析查询

```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM users WHERE email = 'test@example.com';
```

### 关键指标

- **seq_scan**: 顺序扫描次数（应该尽量为 0）
- **idx_scan**: 索引扫描次数（应该尽量高）
- **Execution Time**: 执行时间

## 5. 性能最佳实践

1. **避免 SELECT *** - 只选择需要的列
2. **使用 LIMIT** - 限制返回数量
3. **合理使用缓存** - Redis 缓存热点数据
4. **连接池配置** - 合理设置连接池大小
5. **定期分析表** - ANALYZE 更新统计信息
