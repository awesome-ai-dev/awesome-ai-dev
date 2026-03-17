---
name: backend-orm
description: ORM 使用 - Prisma/Drizzle/SQLAlchemy/TypeORM
---

# ORM 使用

## Prisma (Node.js)

```typescript
// Schema
model User {
  id    Int     @id @default(autoincrement())
  email String  @unique
  posts Post[]
}

model Post {
  id     Int    @id @default(autoincrement())
  title  String
  author User   @relation(fields: [authorId], references: [id])
  authorId Int
}

// 查询
const users = await prisma.user.findMany({
  include: { posts: true }
});
```

## Drizzle (Node.js)

```typescript
// Schema
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).unique(),
});

export type User = typeof users.$inferSelect;

// 查询
const result = await db.select().from(users).all();
```

## SQLAlchemy (Python)

```python
# Model
class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True)
    posts = relationship('Post', back_populates='author')

# Query
users = session.query(User).all()
```

## TypeORM (Node.js)

```typescript
@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;
  
  @Column({ unique: true })
  email: string;
  
  @OneToMany(() => Post, post => post.author)
  posts: Post[];
}
```

## 选择指南
- **Prisma**: 现代、类型安全
- **Drizzle**: 轻量、性能好
- **SQLAlchemy**: Python 标准
- **TypeORM**: NestJS 常用

## 参考
- `.cursor/rules/nestjs.mdc`
