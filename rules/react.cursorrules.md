# React 开发规范

## 项目结构

```
src/
├── components/
│   ├── ui/                 # 基础 UI 组件
│   │   ├── button/
│   │   │   ├── button.tsx
│   │   │   ├── button.test.tsx
│   │   │   └── index.ts
│   │   └── input/
│   ├── forms/              # 表单组件
│   ├── layouts/            # 布局组件
│   └── features/           # 业务功能组件
│       └── user/
│           ├── user-list.tsx
│           ├── user-card.tsx
│           └── index.ts
├── hooks/                  # 自定义 Hooks
│   ├── use-debounce.ts
│   ├── use-local-storage.ts
│   └── use-media-query.ts
├── stores/                 # 状态管理
│   └── user-store.ts
├── services/               # API 服务
│   ├── api-client.ts
│   └── user-service.ts
├── types/                  # TypeScript 类型
│   ├── user.ts
│   └── api.ts
├── utils/                  # 工具函数
│   ├── format.ts
│   └── validation.ts
├── styles/                 # 全局样式
├── constants/              # 常量定义
└── App.tsx
```

---

## 组件设计原则

### 函数式组件（强制）

```typescript
// ✅ 函数式组件
export function UserCard({ user }: { user: User }) {
  return (
    <div className="user-card">
      <span>{user.name}</span>
    </div>
  );
}

// ❌ 禁止使用 Class 组件
class UserCard extends React.Component {} // 不要用
```

### 组件命名

```typescript
// ✅ 文件名：kebab-case
user-profile.tsx
use-user.ts

// ✅ 组件名：PascalCase
export function UserProfile() {}

// ✅ Hook 名：use 前缀 + camelCase
export function useUser() {}

// ✅ 事件处理函数：handle 前缀
const handleClick = () => {};
const handleSubmit = () => {};
```

### 组件导出

```typescript
// ✅ 使用命名导出（便于重构和自动导入）
export function Button() {}
export function Input() {}

// ✅ 通过 index.ts 统一导出
// components/ui/index.ts
export { Button } from './button';
export { Input } from './input';

// ❌ 避免默认导出（除非是页面组件）
export default function Button() {} // 不推荐
```

---

## Props 设计

### 类型定义

```typescript
// ✅ 使用 interface 定义 Props
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  children: React.ReactNode;
  onClick?: () => void;
}

export function Button({
  variant = 'primary',
  size = 'md',
  disabled = false,
  loading = false,
  children,
  onClick,
}: ButtonProps) {
  return (
    <button
      className={cn('btn', `btn-${variant}`, `btn-${size}`)}
      disabled={disabled || loading}
      onClick={onClick}
    >
      {loading ? <Spinner /> : children}
    </button>
  );
}
```

### 扩展原生元素

```typescript
// ✅ 继承原生元素属性
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary';
  loading?: boolean;
}

export function Button({ 
  variant = 'primary', 
  loading, 
  children, 
  className,
  ...props 
}: ButtonProps) {
  return (
    <button
      className={cn('btn', `btn-${variant}`, className)}
      {...props}
    >
      {loading ? <Spinner /> : children}
    </button>
  );
}
```

### 组合模式

```typescript
// ✅ 复合组件模式
interface CardProps {
  children: React.ReactNode;
}

function Card({ children }: CardProps) {
  return <div className="card">{children}</div>;
}

function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="card-header">{children}</div>;
}

function CardBody({ children }: { children: React.ReactNode }) {
  return <div className="card-body">{children}</div>;
}

// 组合导出
Card.Header = CardHeader;
Card.Body = CardBody;

export { Card };

// 使用
<Card>
  <Card.Header>标题</Card.Header>
  <Card.Body>内容</Card.Body>
</Card>
```

---

## Hooks 使用规范

### useState

```typescript
// ✅ 状态初始化
const [count, setCount] = useState(0);
const [user, setUser] = useState<User | null>(null);
const [items, setItems] = useState<Item[]>([]);

// ✅ 函数式更新（依赖前一个状态时）
setCount(prev => prev + 1);
setItems(prev => [...prev, newItem]);

// ✅ 惰性初始化（昂贵的计算）
const [data, setData] = useState(() => computeExpensiveValue());
```

### useEffect

```typescript
// ✅ 数据获取
useEffect(() => {
  const controller = new AbortController();
  
  async function fetchData() {
    try {
      const res = await fetch('/api/users', { signal: controller.signal });
      const data = await res.json();
      setUsers(data);
    } catch (error) {
      if (error.name !== 'AbortError') {
        setError(error);
      }
    }
  }
  
  fetchData();
  
  return () => controller.abort(); // 清理函数
}, []);

// ✅ 事件监听
useEffect(() => {
  function handleResize() {
    setWidth(window.innerWidth);
  }
  
  window.addEventListener('resize', handleResize);
  return () => window.removeEventListener('resize', handleResize);
}, []);

// ❌ 避免：遗漏依赖
useEffect(() => {
  fetchUser(userId); // userId 变化不会触发
}, []); // 缺少 userId
```

### useMemo & useCallback

```typescript
// ✅ useMemo：缓存计算结果
const sortedItems = useMemo(() => {
  return items.sort((a, b) => a.name.localeCompare(b.name));
}, [items]);

// ✅ useCallback：缓存函数引用（传递给子组件时）
const handleDelete = useCallback((id: string) => {
  setItems(prev => prev.filter(item => item.id !== id));
}, []);

// ✅ 配合 React.memo 使用
const MemoizedChild = React.memo(function Child({ onClick }: { onClick: () => void }) {
  return <button onClick={onClick}>Click</button>;
});

function Parent() {
  const handleClick = useCallback(() => {
    console.log('clicked');
  }, []);
  
  return <MemoizedChild onClick={handleClick} />;
}
```

### useRef

```typescript
// ✅ DOM 引用
function TextInput() {
  const inputRef = useRef<HTMLInputElement>(null);
  
  const focus = () => {
    inputRef.current?.focus();
  };
  
  return <input ref={inputRef} />;
}

// ✅ 保存可变值（不触发重渲染）
function Timer() {
  const intervalRef = useRef<number | null>(null);
  
  useEffect(() => {
    intervalRef.current = setInterval(() => {
      // ...
    }, 1000);
    
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, []);
}
```

---

## 自定义 Hooks

### 命名规范

```typescript
// ✅ 必须以 use 开头
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
}
```

### 常用自定义 Hooks

```typescript
// useLocalStorage
export function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch {
      return initialValue;
    }
  });

  const setValue = (value: T | ((val: T) => T)) => {
    const valueToStore = value instanceof Function ? value(storedValue) : value;
    setStoredValue(valueToStore);
    window.localStorage.setItem(key, JSON.stringify(valueToStore));
  };

  return [storedValue, setValue] as const;
}

// useToggle
export function useToggle(initialValue = false) {
  const [value, setValue] = useState(initialValue);
  
  const toggle = useCallback(() => setValue(v => !v), []);
  const setTrue = useCallback(() => setValue(true), []);
  const setFalse = useCallback(() => setValue(false), []);
  
  return { value, toggle, setTrue, setFalse };
}

// useAsync
export function useAsync<T>(asyncFn: () => Promise<T>, deps: any[] = []) {
  const [state, setState] = useState<{
    loading: boolean;
    error: Error | null;
    data: T | null;
  }>({
    loading: true,
    error: null,
    data: null,
  });

  useEffect(() => {
    setState(s => ({ ...s, loading: true }));
    
    asyncFn()
      .then(data => setState({ loading: false, error: null, data }))
      .catch(error => setState({ loading: false, error, data: null }));
  }, deps);

  return state;
}
```

---

## 状态管理 (Zustand)

```typescript
// stores/user-store.ts
import { create } from 'zustand';
import { persist, devtools } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

interface User {
  id: string;
  name: string;
  email: string;
}

interface UserState {
  user: User | null;
  isLoading: boolean;
  
  // Actions
  setUser: (user: User | null) => void;
  updateUser: (updates: Partial<User>) => void;
  fetchUser: (id: string) => Promise<void>;
  logout: () => void;
}

export const useUserStore = create<UserState>()(
  devtools(
    persist(
      immer((set, get) => ({
        user: null,
        isLoading: false,

        setUser: (user) => set({ user }),
        
        updateUser: (updates) => set((state) => {
          if (state.user) {
            Object.assign(state.user, updates);
          }
        }),
        
        fetchUser: async (id) => {
          set({ isLoading: true });
          try {
            const res = await fetch(`/api/users/${id}`);
            const user = await res.json();
            set({ user, isLoading: false });
          } catch {
            set({ isLoading: false });
          }
        },
        
        logout: () => set({ user: null }),
      })),
      { name: 'user-storage' }
    )
  )
);

// 使用：选择性订阅（避免不必要的重渲染）
function UserName() {
  const name = useUserStore((state) => state.user?.name);
  return <span>{name}</span>;
}
```

---

## 数据请求 (TanStack Query)

### 基础配置

```typescript
// providers/query-provider.tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 分钟
      gcTime: 1000 * 60 * 30, // 30 分钟
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

export function QueryProvider({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools />
    </QueryClientProvider>
  );
}
```

### 查询 Hooks

```typescript
// hooks/use-users.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { userService } from '@/services/user-service';

// 列表查询
export function useUsers(params?: { page?: number; keyword?: string }) {
  return useQuery({
    queryKey: ['users', params],
    queryFn: () => userService.getUsers(params),
  });
}

// 详情查询
export function useUser(id: string) {
  return useQuery({
    queryKey: ['users', id],
    queryFn: () => userService.getUser(id),
    enabled: !!id, // 只有 id 存在时才查询
  });
}

// 创建
export function useCreateUser() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: userService.createUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}

// 更新
export function useUpdateUser() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: UpdateUserInput }) =>
      userService.updateUser(id, data),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      queryClient.invalidateQueries({ queryKey: ['users', id] });
    },
  });
}

// 乐观更新
export function useToggleFavorite() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => userService.toggleFavorite(id),
    onMutate: async (id) => {
      await queryClient.cancelQueries({ queryKey: ['users', id] });
      
      const previousUser = queryClient.getQueryData(['users', id]);
      
      queryClient.setQueryData(['users', id], (old: User) => ({
        ...old,
        isFavorite: !old.isFavorite,
      }));
      
      return { previousUser };
    },
    onError: (err, id, context) => {
      queryClient.setQueryData(['users', id], context?.previousUser);
    },
    onSettled: (_, __, id) => {
      queryClient.invalidateQueries({ queryKey: ['users', id] });
    },
  });
}
```

---

## 表单处理 (React Hook Form + Zod)

```typescript
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

// Schema 定义
const userSchema = z.object({
  name: z.string().min(2, '至少 2 个字符').max(50, '最多 50 个字符'),
  email: z.string().email('请输入有效邮箱'),
  age: z.number().min(1).max(120).optional(),
  role: z.enum(['admin', 'user', 'guest']),
  bio: z.string().max(500).optional(),
});

type UserFormData = z.infer<typeof userSchema>;

// 表单组件
export function UserForm({ 
  defaultValues,
  onSubmit 
}: { 
  defaultValues?: Partial<UserFormData>;
  onSubmit: (data: UserFormData) => Promise<void>;
}) {
  const {
    register,
    handleSubmit,
    control,
    formState: { errors, isSubmitting, isDirty },
    reset,
    watch,
  } = useForm<UserFormData>({
    resolver: zodResolver(userSchema),
    defaultValues: {
      role: 'user',
      ...defaultValues,
    },
  });

  const onSubmitHandler = async (data: UserFormData) => {
    try {
      await onSubmit(data);
      reset();
    } catch (error) {
      // 错误处理
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmitHandler)} className="space-y-4">
      <div>
        <label htmlFor="name">名称</label>
        <input
          id="name"
          {...register('name')}
          className={cn('input', errors.name && 'input-error')}
        />
        {errors.name && (
          <span className="text-red-500 text-sm">{errors.name.message}</span>
        )}
      </div>

      <div>
        <label htmlFor="email">邮箱</label>
        <input
          id="email"
          type="email"
          {...register('email')}
          className={cn('input', errors.email && 'input-error')}
        />
        {errors.email && (
          <span className="text-red-500 text-sm">{errors.email.message}</span>
        )}
      </div>

      <div>
        <label htmlFor="role">角色</label>
        <select id="role" {...register('role')} className="select">
          <option value="user">用户</option>
          <option value="admin">管理员</option>
          <option value="guest">访客</option>
        </select>
      </div>

      <button
        type="submit"
        disabled={isSubmitting || !isDirty}
        className="btn btn-primary"
      >
        {isSubmitting ? '提交中...' : '提交'}
      </button>
    </form>
  );
}
```

---

## 性能优化

### React.memo

```typescript
// ✅ 纯展示组件使用 memo
const UserCard = React.memo(function UserCard({ user }: { user: User }) {
  return (
    <div className="user-card">
      <span>{user.name}</span>
    </div>
  );
});

// ✅ 自定义比较函数
const UserCard = React.memo(
  function UserCard({ user }: { user: User }) {
    return <div>{user.name}</div>;
  },
  (prevProps, nextProps) => prevProps.user.id === nextProps.user.id
);
```

### 虚拟列表

```typescript
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualList({ items }: { items: Item[] }) {
  const parentRef = useRef<HTMLDivElement>(null);
  
  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50,
    overscan: 5,
  });

  return (
    <div ref={parentRef} className="h-[400px] overflow-auto">
      <div
        style={{
          height: `${virtualizer.getTotalSize()}px`,
          position: 'relative',
        }}
      >
        {virtualizer.getVirtualItems().map((virtualItem) => (
          <div
            key={virtualItem.key}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${virtualItem.size}px`,
              transform: `translateY(${virtualItem.start}px)`,
            }}
          >
            {items[virtualItem.index].name}
          </div>
        ))}
      </div>
    </div>
  );
}
```

### 代码分割

```typescript
import { lazy, Suspense } from 'react';

// 懒加载组件
const HeavyComponent = lazy(() => import('./heavy-component'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <HeavyComponent />
    </Suspense>
  );
}

// 路由懒加载
const routes = [
  {
    path: '/dashboard',
    element: lazy(() => import('./pages/dashboard')),
  },
  {
    path: '/settings',
    element: lazy(() => import('./pages/settings')),
  },
];
```

---

## 测试规范

```typescript
// user-card.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserCard } from './user-card';

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
  };

  it('renders user name', () => {
    render(<UserCard user={mockUser} />);
    expect(screen.getByText('John Doe')).toBeInTheDocument();
  });

  it('calls onClick when clicked', async () => {
    const handleClick = vi.fn();
    render(<UserCard user={mockUser} onClick={handleClick} />);
    
    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledWith(mockUser.id);
  });

  it('shows loading state', () => {
    render(<UserCard user={mockUser} loading />);
    expect(screen.getByTestId('spinner')).toBeInTheDocument();
  });
});
```

---

## 常见错误避免

```markdown
❌ 不要在渲染期间修改 state
❌ 不要直接修改 state（使用 setState）
❌ 不要在 useEffect 依赖数组中遗漏依赖
❌ 不要在 useEffect 中返回非函数值
❌ 不要在条件语句中使用 Hooks
❌ 不要在循环中使用 Hooks
❌ 不要滥用 useMemo/useCallback（先测量再优化）
❌ 不要在子组件中直接修改 props
❌ 不要忘记给列表元素添加唯一的 key
❌ 不要使用数组索引作为 key（除非列表是静态的）
```
