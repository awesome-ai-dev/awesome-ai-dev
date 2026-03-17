# ORM 指南

## Prisma Schema 最佳实践

### 关系
```prisma
model User {
  id    String  @id @default(uuid())
  posts Post[]
}

model Post {
  id      String @id @default(uuid())
  userId  String
  user    User   @relation(fields: [userId], references: [id])
}
```

### 索引
```prisma
model User {
  email  String @unique
  status String @index
  
  @@index([status, createdAt])
}
```

### 软删除
```prisma
model User {
  deletedAt DateTime?
  
  @@query->(delete: { where: { deletedAt: null } })
}
```

## Drizzle Schema

```typescript
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  createdAt: timestamp('created_at').defaultNow(),
});

export type User = typeof users.$inferSelect;
```

## 性能优化

### 1. 避免 N+1
```typescript
// ❌ N+1
const users = await prisma.user.findMany();
for (const user of users) {
  const posts = await prisma.post.findMany({ where: { userId: user.id }});
}

// ✅ 预加载
const users = await prisma.user.findMany({
  include: { posts: true }
});
```

### 2. 选择字段
```typescript
// ❌ 查询所有
const users = await prisma.user.findMany();

// ✅ 只查询需要的
const users = await prisma.user.findMany({
  select: { id: true, name: true }
});
```

### 3. 分页
```typescript
const users = await prisma.user.findMany({
  skip: (page - 1) * pageSize,
  take: pageSize,
  orderBy: { createdAt: 'desc' }
});
```

## 迁移策略
1. 开发环境: prisma migrate dev
2. 生产环境: prisma migrate deploy
3. 紧急修复: prisma db push (仅开发)

---
