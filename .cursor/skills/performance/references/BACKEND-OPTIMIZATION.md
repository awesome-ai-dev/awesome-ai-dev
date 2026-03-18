# 后端性能优化指南

## 1. 数据库优化

### 连接池配置

```typescript
// Prisma 连接池
// .env
DATABASE_URL="postgresql://user:pass@localhost:5432/db?connection_limit=20&pool_timeout=10"

// NestJS/TypeORM
export const DatabaseConfig: TypeOrmModuleOptions = {
  type: 'postgres',
  poolSize: 20,
  acquire: 30000,
  idle: 10000,
};
```

### 查询优化

```typescript
// ✅ 批量查询替代循环
// ❌
for (const userId of userIds) {
  const user = await prisma.user.findUnique({ where: { id: userId } });
}

// ✅
const users = await prisma.user.findMany({
  where: { id: { in: userIds } }
});

// ✅ 只选择需要的字段
const users = await prisma.user.findMany({
  select: { id: true, name: true, email: true }
});
```

### 缓存策略

```typescript
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

// 缓存查询结果
async function getCachedUser(id: string) {
  const cacheKey = `user:${id}`;
  
  const cached = await redis.get(cacheKey);
  if (cached) {
    return JSON.parse(cached);
  }
  
  const user = await prisma.user.findUnique({ where: { id } });
  
  if (user) {
    await redis.setex(cacheKey, 3600, JSON.stringify(user)); // 1 hour
  }
  
  return user;
}

// 缓存失效
async function invalidateUserCache(id: string) {
  await redis.del(`user:${id}`);
}
```

## 2. API 优化

### 分页

```typescript
// ✅ 游标分页（更高效）
app.get('/posts', async (req, res) => {
  const { cursor, limit = 10 } = req.query;
  
  const posts = await prisma.post.findMany({
    take: Number(limit) + 1,
    cursor: cursor ? { id: cursor } : undefined,
    skip: cursor ? 1 : 0,
    orderBy: { createdAt: 'desc' },
  });
  
  const hasMore = posts.length > Number(limit);
  const data = hasMore ? posts.slice(0, -1) : posts;
  
  return res.json({
    data,
    nextCursor: hasMore ? data[data.length - 1].id : null,
  });
});
```

### 压缩

```typescript
import compression from 'compression';

app.use(compression({
  threshold: 1024,
  level: 6,
}));
```

## 3. 异步处理

### 消息队列

```typescript
import Bull from 'bull';

const emailQueue = new Bull('email');

// 生产者
async function sendWelcomeEmail(userId: string) {
  await emailQueue.add({
    userId,
    type: 'welcome',
  }, {
    delay: 5000, // 延迟 5 秒
    attempts: 3,
  });
}

// 消费者
emailQueue.process(async (job) => {
  const { userId, type } = job.data;
  await sendEmail(userId, type);
});
```

### 批处理

```typescript
// 批量处理任务
async function processBatch<T>(
  items: T[],
  processor: (item: T) => Promise<void>,
  batchSize = 100
) {
  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    await Promise.all(batch.map(processor));
  }
}
```

## 4. 内存优化

### 流处理大文件

```typescript
import fs from 'fs';
import { Transform } from 'stream';

async function processLargeFile(filePath: string) {
  return new Promise((resolve, reject) => {
    const transform = new Transform({
      transform(chunk, encoding, callback) {
        // 处理每一行
        const processed = chunk.toString().toUpperCase();
        callback(null, processed);
      }
    });
    
    const readStream = fs.createReadStream(filePath);
    const writeStream = fs.createWriteStream('output.txt');
    
    readStream
      .pipe(transform)
      .pipe(writeStream)
      .on('finish', resolve)
      .on('error', reject);
  });
}
```

### 对象池

```typescript
class ObjectPool<T> {
  private pool: T[] = [];
  private createFn: () => T;
  private resetFn: (obj: T) => void;
  
  constructor(
    createFn: () => T,
    resetFn: (obj: T) => void,
    private maxSize = 10
  ) {
    this.createFn = createFn;
    this.resetFn = resetFn;
  }
  
  acquire(): T {
    return this.pool.pop() || this.createFn();
  }
  
  release(obj: T): void {
    this.resetFn(obj);
    if (this.pool.length < this.maxSize) {
      this.pool.push(obj);
    }
  }
}
```

## 5. 并发控制

### 信号量

```typescript
import { Semaphore } from 'async-mutex';

const semaphore = new Semaphore(5); // 最多 5 个并发

async function limitedRequest(url: string) {
  const [value, release] = await semaphore.acquire();
  try {
    return await fetch(url);
  } finally {
    release();
  }
}
```

### 限流

```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests',
});
```

## 6. 监控与诊断

### 性能指标

```typescript
import { performance } from 'perf_hooks';

async function measurePerformance<T>(
  fn: () => Promise<T>,
  label: string
): Promise<T> {
  const start = performance.now();
  
  try {
    return await fn();
  } finally {
    const duration = performance.now() - start;
    console.log(`${label}: ${duration}ms`);
    
    // 发送指标到监控系统
    metrics.record(`performance.${label}`, duration);
  }
}
```

### 健康检查

```typescript
app.get('/health', async (req, res) => {
  const checks = await Promise.allSettled([
    checkDatabase(),
    checkRedis(),
    checkExternalAPI(),
  ]);
  
  const status = checks.every(c => c.status === 'fulfilled') 
    ? 'healthy' 
    : 'degraded';
    
  res.status(status === 'healthy' ? 200 : 503).json({
    status,
    checks: checks.map((c, i) => ({
      name: ['db', 'redis', 'api'][i],
      status: c.status === 'fulfilled' ? 'up' : 'down',
    })),
  });
});
```
