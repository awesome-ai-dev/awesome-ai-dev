# 数据库索引设计指南

## 索引基础

### 什么是索引

索引是一种特殊的数据结构，用于加速数据检索。就像书籍的目录一样，索引帮助数据库快速定位数据。

### 索引的优缺点

| 优点 | 缺点 |
|-----|------|
| 加快查询速度 | 占用存储空间 |
| 减少 I/O 操作 | 降低写入性能 |
| 加速排序操作 | 需要维护 |

## 索引类型

### 1. B-Tree 索引（默认）

适用于：

- 等值查询：`WHERE email = 'xxx'`
- 范围查询：`WHERE age > 18`
- 排序：`ORDER BY created_at`

```sql
CREATE INDEX idx_users_email ON users(email);
```

### 2. Hash 索引

适用于：精确等值匹配

```sql
CREATE INDEX idx_users_email ON users USING HASH(email);
```

### 3. GiST 索引

适用于：地理空间数据、全文搜索

```sql
CREATE INDEX idx_locations_geo ON locations USING GIST(coordinates);
```

### 4. GIN 索引

适用于：数组、全文搜索、JSONB

```sql
CREATE INDEX idx_tags ON posts USING GIN(tags);
```

## 复合索引

### 列顺序原则

最常用的列放在前面：

```sql
-- 经常同时查询 status 和 created_at
CREATE INDEX idx_orders_status_created ON orders(status, created_at);

-- 查询顺序：WHERE status = 'pending' AND created_at > '2024-01-01'
--         WHERE status = 'pending'
-- 不能用于：WHERE created_at > '2024-01-01' (不使用第一列)
```

### 选择性

高选择性的列放前面：

```sql
-- status (低选择性) vs id (高选择性)
-- 如果经常用 id 查询，放前面
CREATE INDEX idx_orders_id_status ON orders(id, status);
```

## 索引设计原则

### 1. 识别慢查询

```sql
-- 查看查询统计
SELECT query, calls, mean_exec_time 
FROM pg_stat_statements 
ORDER BY mean_exec_time DESC 
LIMIT 10;
```

### 2. 查看表统计信息

```sql
-- 查看表的大小和行数
SELECT 
    relname,
    n_live_tup as row_count,
    pg_size_pretty(pg_total_relation_size(relid)) as size
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;
```

### 3. 外键必须建索引

```sql
-- 外键用于关联查询，必须建索引
CREATE INDEX idx_posts_author ON posts(author_id);
```

## 常见场景

### 用户系统

```sql
-- 登录查询
CREATE INDEX idx_users_email ON users(email);

-- 用户列表分页
CREATE INDEX idx_users_created ON users(created_at DESC);

-- 搜索用户
CREATE INDEX idx_users_name ON users(name) WHERE name IS NOT NULL;
```

### 订单系统

```sql
-- 订单查询
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);

-- 时间范围查询
CREATE INDEX idx_orders_created ON orders(created_at DESC);

-- 复合查询
CREATE INDEX idx_orders_status_user ON orders(status, user_id);
```

### 日志系统

```sql
-- 时间+级别查询
CREATE INDEX idx_logs_created_level ON logs(created_at, level);

-- 用户行为日志
CREATE INDEX idx_logs_user_action ON logs(user_id, action);
```

## 索引维护

### 查看索引使用情况

```sql
-- 查找未使用的索引
SELECT 
    schemaname,
    relname,
    indexrelname,
    idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY pg_relation_size(indexrelid) DESC;
```

### 删除冗余索引

```sql
-- 查找重复索引
SELECT 
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE (schemaname, tablename, indexdef) IN (
    SELECT schemaname, tablename, indexdef
    FROM pg_indexes
    GROUP BY 1,2,3
    HAVING COUNT(*) > 1
);
```

### 重建索引

```sql
-- 重建单个索引
REINDEX INDEX idx_users_email;

-- 重建表的所有索引
REINDEX TABLE users;
```

## Prisma 中的索引

```prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique  // 自动创建唯一索引
  name      String?
  posts     Post[]
  
  // 自定义索引
  @@index([name])
  @@index([createdAt(sort: Desc)])
}

model Order {
  id        Int      @id
  userId    Int
  status    String
  createdAt DateTime @default(now())
  
  // 复合索引
  @@index([status, createdAt(sort: Desc)])
}
```
