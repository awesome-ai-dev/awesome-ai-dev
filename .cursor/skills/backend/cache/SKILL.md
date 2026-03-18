---
name: backend-cache
description: 缓存策略 - Redis/Memcached/本地缓存
---

# 缓存策略

## Redis

### 基础操作

```typescript
import Redis from 'ioredis';

const redis = new Redis();

// 字符串
await redis.set('key', 'value');
const value = await redis.get('key');

// 哈希
await redis.hset('user:1', 'name', 'John');
const user = await redis.hgetall('user:1');

// 列表
await redis.rpush('queue', 'item1');
const item = await redis.lpop('queue');

// 过期
await redis.setex('token', 3600, 'abc'); // 1小时过期
```

### 缓存模式

```typescript
// Cache-Aside
async function getUser(id: string) {
  const cacheKey = `user:${id}`;
  const cached = await redis.get(cacheKey);
  if (cached) return JSON.parse(cached);
  
  const user = await db.user.findById(id);
  await redis.setex(cacheKey, 3600, JSON.stringify(user));
  return user;
}

// Write-Through
async function updateUser(id: string, data: User) {
  await db.user.update(id, data);
  await redis.setex(`user:${id}`, 3600, JSON.stringify(data));
}
```

## 缓存策略详解

| 策略 | 适用场景 |
| --- | --- |
| Cache-Aside | 读多写少 |
| Write-Through | 数据一致性要求高 |
| Write-Behind | 写入性能要求高 |
| TTL | 过期数据 |

## 分布式锁

```typescript
async function withLock(key: string, fn: () => Promise<T>) {
  const lock = await redis.set(key, '1', 'EX', 10, 'NX');
  if (!lock) throw new Error('Lock failed');
  
  try {
    return await fn();
  } finally {
    await redis.del(key);
  }
}
```

## 最佳实践

1. 合理设置 TTL
2. 缓存穿透防护
3. 缓存雪崩处理
4. 热点数据预热

## 参考

- `.cursor/rules/nestjs.mdc`
