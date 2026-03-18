# 代码规范参考

## 1. TypeScript 规范

### 类型定义

```typescript
// ✅ 使用 interface 定义对象类型
interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
}

// ✅ 使用 type 定义联合类型
type Status = 'pending' | 'active' | 'inactive';

// ✅ 避免 any，使用 unknown
function parse(data: unknown): User {
  if (isUser(data)) {
    return data;
  }
  throw new Error('Invalid data');
}

// ✅ 可选属性
interface Config {
  timeout?: number;
  retries?: number;
}
```text

### 函数

```typescript
// ✅ 明确返回类型
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// ✅ 箭头函数用于回调
const debounce = <T extends (...args: any[]) => any>(
  fn: T,
  delay: number
): ((...args: Parameters<T>) => void) => {
  let timeoutId: NodeJS.Timeout;
  return (...args: Parameters<T>) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
};
```text

---

## 2. React 规范

### 组件结构

```typescript
// 1. 导入
import { useState, useEffect } from 'react';
import type { User } from '@/types';

// 2. 类型定义
interface Props {
  user: User;
  onUpdate: (user: User) => void;
}

// 3. 组件定义
export function UserProfile({ user, onUpdate }: Props) {
  // 4. State
  const [isEditing, setIsEditing] = useState(false);
  
  // 5. Effects
  useEffect(() => {
    // 副作用
  }, []);
  
  // 6. Handlers
  const handleEdit = () => setIsEditing(true);
  
  // 7. Render
  return (
    <div>
      {isEditing ? <EditForm /> : <Display />}
    </div>
  );
}
```text

### Hooks 规范

```typescript
// ✅ 自定义 Hook 以 use 开头
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);
  
  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(handler);
  }, [value, delay]);
  
  return debouncedValue;
}

// ✅ 条件判断在 Hook 之外
function Component() {
  const { data, loading } = useQuery();
  
  if (loading) return <Skeleton />;
  
  return <List items={data} />;
}
```

---

## 3. 命名规范

### 文件命名

```text
components/
├── UserProfile.tsx        # 组件: PascalCase
├── use-user.ts           # Hook: use- 前缀
├── utils.ts              # 工具: camelCase
├── constants.ts          # 常量: camelCase
├── types.ts              # 类型: camelCase
└── api-client.ts         # API: camelCase
```

### 命名惯例

```typescript
// 变量/函数: camelCase
const userName = 'John';
function getUserById() {}

// 常量: UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';

// 类/接口: PascalCase
class UserService {}
interface UserProfile {}

// 私有属性: _ 前缀（可选）
class Service {
  private _cache: Map<string, any>;
}
```

---

## 4. 导入顺序

```typescript
// 1. React/框架
import { useState, useEffect } from 'react';
import { useRouter } from 'next/router';

// 2. 外部库
import { z } from 'zod';
import { format } from 'date-fns';

// 3. 项目内部
import { useAuth } from '@/hooks';
import { Button } from '@/components/ui';

// 4. 类型导入
import type { User, Order } from '@/types';

// 5. 相对路径
import { formatDate } from '../utils/date';
import { calculateTotal } from './calculator';

// 6. 样式（可选）
import styles from './Button.module.css';
```

---

## 5. 错误处理

```typescript
// ✅ 统一错误类型
class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'AppError';
  }
}

// ✅ 使用 Result 类型
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const user = await api.getUser(id);
    return { ok: true, value: user };
  } catch (error) {
    return { ok: false, error: error as Error };
  }
}

// 使用
const result = await fetchUser('1');
if (result.ok) {
  console.log(result.value);
} else {
  console.error(result.error);
}
```

---

## 6. 注释规范

```typescript
// ✅ 解释为什么，而不是做什么
// 使用 setTimeout 避免立即触发，防止初始渲染闪烁
setTimeout(() => {
  startAnimation();
}, 100);

// ✅ JSDoc 用于公共 API
/**
 * 格式化用户显示名称
 * @param user - 用户对象
 * @returns 格式化的显示名称
 * @example
 * formatUserName({ firstName: 'John', lastName: 'Doe' })
 * // => 'John Doe'
 */
function formatUserName(user: User): string {
  return `${user.firstName} ${user.lastName}`;
}

// ❌ 解释代码做什么（代码本身已经说明）
// 设置 count 为 0
const count = 0;
```
