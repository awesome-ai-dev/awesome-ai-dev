# Next.js 开发规范 (App Router)

## 项目结构

```
src/
├── app/                    # App Router 路由
│   ├── (auth)/            # 路由组（认证相关）
│   │   ├── login/
│   │   └── register/
│   ├── (dashboard)/       # 路由组（后台）
│   │   ├── layout.tsx
│   │   └── settings/
│   ├── api/               # API Routes
│   │   └── [...]/route.ts
│   ├── layout.tsx         # 根布局
│   ├── page.tsx           # 首页
│   ├── loading.tsx        # 全局 Loading
│   ├── error.tsx          # 全局错误处理
│   └── not-found.tsx      # 404 页面
├── components/
│   ├── ui/                # 基础 UI 组件
│   ├── forms/             # 表单组件
│   ├── layouts/           # 布局组件
│   └── features/          # 业务组件
├── lib/                   # 工具库
│   ├── api.ts             # API 客户端
│   ├── utils.ts           # 工具函数
│   └── validations.ts     # Zod Schema
├── hooks/                 # 自定义 Hooks
├── stores/                # 状态管理
├── types/                 # TypeScript 类型
├── styles/                # 全局样式
└── config/                # 配置文件
```

---

## 代码风格

### 命名规范

```typescript
// ✅ 文件命名
page.tsx                    // 页面文件
layout.tsx                  // 布局文件
loading.tsx                 // 加载状态
error.tsx                   // 错误处理
user-profile.tsx            // 组件：kebab-case
use-user.ts                 // Hook：use- 前缀

// ✅ 组件命名：PascalCase
export function UserProfile() {}
export default function HomePage() {}

// ✅ 导出方式
// 页面组件使用 default export
export default function Page() {}
// 其他组件使用 named export
export function Button() {}
```

### 组件类型选择

```typescript
// ✅ Server Component (默认) - 数据获取、SEO
// app/users/page.tsx
export default async function UsersPage() {
  const users = await getUsers(); // 直接在组件中获取数据
  return <UserList users={users} />;
}

// ✅ Client Component - 交互、状态、浏览器 API
// components/counter.tsx
'use client';

import { useState } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

---

## 数据获取

### Server Component 数据获取

```typescript
// ✅ 直接在组件中 fetch（自动去重和缓存）
async function getUser(id: string) {
  const res = await fetch(`${process.env.API_URL}/users/${id}`, {
    next: { revalidate: 60 }, // ISR: 60 秒重新验证
  });
  
  if (!res.ok) {
    throw new Error('Failed to fetch user');
  }
  
  return res.json();
}

export default async function UserPage({ params }: { params: { id: string } }) {
  const user = await getUser(params.id);
  return <UserProfile user={user} />;
}
```

### 并行数据获取

```typescript
// ✅ 使用 Promise.all 并行获取
export default async function DashboardPage() {
  const [user, posts, stats] = await Promise.all([
    getUser(),
    getPosts(),
    getStats(),
  ]);

  return (
    <Dashboard user={user} posts={posts} stats={stats} />
  );
}
```

### Client Component 数据获取 (TanStack Query)

```typescript
'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

// ✅ 查询数据
export function UserList() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['users'],
    queryFn: () => fetch('/api/users').then(res => res.json()),
  });

  if (isLoading) return <Skeleton />;
  if (error) return <ErrorMessage error={error} />;
  
  return <ul>{data.map(user => <UserItem key={user.id} user={user} />)}</ul>;
}

// ✅ 修改数据
export function CreateUserForm() {
  const queryClient = useQueryClient();
  
  const mutation = useMutation({
    mutationFn: (newUser: CreateUserInput) =>
      fetch('/api/users', {
        method: 'POST',
        body: JSON.stringify(newUser),
      }).then(res => res.json()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });

  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      mutation.mutate({ name, email });
    }}>
      {/* ... */}
    </form>
  );
}
```

---

## API Routes

### 基础 CRUD

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { prisma } from '@/lib/prisma';

// GET /api/users
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const page = parseInt(searchParams.get('page') ?? '1');
  const pageSize = parseInt(searchParams.get('pageSize') ?? '10');

  const [users, total] = await Promise.all([
    prisma.user.findMany({
      skip: (page - 1) * pageSize,
      take: pageSize,
      orderBy: { createdAt: 'desc' },
    }),
    prisma.user.count(),
  ]);

  return NextResponse.json({
    data: users,
    meta: { page, pageSize, total },
  });
}

// POST /api/users
const createUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const data = createUserSchema.parse(body);
    
    const user = await prisma.user.create({ data });
    
    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', details: error.errors },
        { status: 400 }
      );
    }
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

// app/api/users/[id]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const user = await prisma.user.findUnique({
    where: { id: parseInt(params.id) },
  });

  if (!user) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 });
  }

  return NextResponse.json(user);
}
```

### 流式响应 (AI/LLM)

```typescript
// app/api/chat/route.ts
import { OpenAIStream, StreamingTextResponse } from 'ai';
import OpenAI from 'openai';

const openai = new OpenAI();

export async function POST(req: Request) {
  const { messages } = await req.json();

  const response = await openai.chat.completions.create({
    model: 'gpt-4',
    stream: true,
    messages,
  });

  const stream = OpenAIStream(response);
  return new StreamingTextResponse(stream);
}
```

---

## 表单处理

### React Hook Form + Zod

```typescript
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const formSchema = z.object({
  name: z.string().min(2, '名称至少 2 个字符'),
  email: z.string().email('请输入有效的邮箱'),
  password: z.string().min(6, '密码至少 6 个字符'),
});

type FormData = z.infer<typeof formSchema>;

export function SignupForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<FormData>({
    resolver: zodResolver(formSchema),
  });

  const onSubmit = async (data: FormData) => {
    try {
      const res = await fetch('/api/auth/signup', {
        method: 'POST',
        body: JSON.stringify(data),
      });
      
      if (!res.ok) throw new Error('注册失败');
      
      reset();
      // 成功处理...
    } catch (error) {
      // 错误处理...
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <input
          {...register('name')}
          placeholder="用户名"
          className="input"
        />
        {errors.name && (
          <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>
        )}
      </div>
      
      <div>
        <input
          {...register('email')}
          type="email"
          placeholder="邮箱"
          className="input"
        />
        {errors.email && (
          <p className="text-red-500 text-sm mt-1">{errors.email.message}</p>
        )}
      </div>
      
      <div>
        <input
          {...register('password')}
          type="password"
          placeholder="密码"
          className="input"
        />
        {errors.password && (
          <p className="text-red-500 text-sm mt-1">{errors.password.message}</p>
        )}
      </div>
      
      <button 
        type="submit" 
        disabled={isSubmitting}
        className="btn btn-primary w-full"
      >
        {isSubmitting ? '提交中...' : '注册'}
      </button>
    </form>
  );
}
```

### Server Actions

```typescript
// app/actions/user.ts
'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { z } from 'zod';
import { prisma } from '@/lib/prisma';

const createUserSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
});

export async function createUser(formData: FormData) {
  const rawData = {
    name: formData.get('name'),
    email: formData.get('email'),
  };

  const validatedData = createUserSchema.parse(rawData);

  await prisma.user.create({
    data: validatedData,
  });

  revalidatePath('/users');
  redirect('/users');
}

// 在组件中使用
// app/users/new/page.tsx
import { createUser } from '@/app/actions/user';

export default function NewUserPage() {
  return (
    <form action={createUser}>
      <input name="name" required />
      <input name="email" type="email" required />
      <button type="submit">创建</button>
    </form>
  );
}
```

---

## 状态管理 (Zustand)

```typescript
// stores/use-user-store.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: string;
  name: string;
  email: string;
}

interface UserStore {
  user: User | null;
  setUser: (user: User | null) => void;
  logout: () => void;
}

export const useUserStore = create<UserStore>()(
  persist(
    (set) => ({
      user: null,
      setUser: (user) => set({ user }),
      logout: () => set({ user: null }),
    }),
    {
      name: 'user-storage',
    }
  )
);

// 使用
'use client';

import { useUserStore } from '@/stores/use-user-store';

export function UserInfo() {
  const { user, logout } = useUserStore();
  
  if (!user) return null;
  
  return (
    <div>
      <span>{user.name}</span>
      <button onClick={logout}>退出</button>
    </div>
  );
}
```

---

## 错误处理

### Error Boundary

```typescript
// app/error.tsx
'use client';

import { useEffect } from 'react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // 上报错误
    console.error(error);
  }, [error]);

  return (
    <div className="flex flex-col items-center justify-center min-h-screen">
      <h2 className="text-2xl font-bold">出错了！</h2>
      <p className="text-gray-600 mt-2">{error.message}</p>
      <button
        onClick={reset}
        className="mt-4 px-4 py-2 bg-blue-500 text-white rounded"
      >
        重试
      </button>
    </div>
  );
}
```

### Not Found

```typescript
// app/not-found.tsx
import Link from 'next/link';

export default function NotFound() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen">
      <h1 className="text-6xl font-bold">404</h1>
      <p className="text-xl text-gray-600 mt-4">页面不存在</p>
      <Link href="/" className="mt-6 text-blue-500 hover:underline">
        返回首页
      </Link>
    </div>
  );
}
```

---

## 加载状态

### Loading UI

```typescript
// app/loading.tsx (全局)
export default function Loading() {
  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500" />
    </div>
  );
}

// app/users/loading.tsx (局部)
import { Skeleton } from '@/components/ui/skeleton';

export default function UsersLoading() {
  return (
    <div className="space-y-4">
      {Array.from({ length: 5 }).map((_, i) => (
        <Skeleton key={i} className="h-16 w-full" />
      ))}
    </div>
  );
}
```

### Suspense 边界

```typescript
import { Suspense } from 'react';

export default function DashboardPage() {
  return (
    <div>
      <h1>Dashboard</h1>
      
      <Suspense fallback={<StatsSkeleton />}>
        <Stats />
      </Suspense>
      
      <Suspense fallback={<ChartSkeleton />}>
        <Chart />
      </Suspense>
    </div>
  );
}
```

---

## 元数据和 SEO

```typescript
// app/layout.tsx
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: {
    default: 'My App',
    template: '%s | My App',
  },
  description: 'My awesome application',
  keywords: ['Next.js', 'React', 'TypeScript'],
  authors: [{ name: 'Your Name' }],
  openGraph: {
    title: 'My App',
    description: 'My awesome application',
    url: 'https://myapp.com',
    siteName: 'My App',
    locale: 'zh_CN',
    type: 'website',
  },
};

// 动态元数据
// app/posts/[slug]/page.tsx
export async function generateMetadata({ params }): Promise<Metadata> {
  const post = await getPost(params.slug);
  
  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      title: post.title,
      description: post.excerpt,
      images: [post.coverImage],
    },
  };
}
```

---

## 中间件

```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value;
  const isAuthPage = request.nextUrl.pathname.startsWith('/login');
  const isProtectedPage = request.nextUrl.pathname.startsWith('/dashboard');

  // 未登录访问保护页面 -> 跳转登录
  if (isProtectedPage && !token) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  // 已登录访问登录页 -> 跳转首页
  if (isAuthPage && token) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/login', '/register'],
};
```

---

## 性能优化

### 图片优化

```typescript
import Image from 'next/image';

export function Avatar({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={100}
      height={100}
      placeholder="blur"
      blurDataURL="/placeholder.png"
      className="rounded-full"
    />
  );
}
```

### 动态导入

```typescript
import dynamic from 'next/dynamic';

// 懒加载组件
const HeavyChart = dynamic(() => import('@/components/heavy-chart'), {
  loading: () => <ChartSkeleton />,
  ssr: false, // 仅客户端渲染
});
```

### 缓存策略

```typescript
// 数据缓存
async function getData() {
  const res = await fetch('https://api.example.com/data', {
    next: {
      revalidate: 3600, // 1 小时缓存
      tags: ['data'], // 用于按需重新验证
    },
  });
  return res.json();
}

// 按需重新验证
import { revalidateTag } from 'next/cache';

export async function updateData() {
  // 更新数据...
  revalidateTag('data'); // 清除缓存
}
```

---

## 常见错误避免

```markdown
❌ 不要在 Server Component 中使用 useState/useEffect
❌ 不要在 Client Component 中直接使用 async/await
❌ 不要忘记在使用 hooks 的组件顶部添加 'use client'
❌ 不要在 Server Action 中返回敏感数据
❌ 不要忘记处理 loading 和 error 状态
❌ 不要在 useEffect 依赖数组中遗漏依赖
❌ 不要直接在组件中写大量 CSS，使用 Tailwind 类
❌ 不要忘记图片的 alt 属性
❌ 不要在客户端暴露环境变量（使用 NEXT_PUBLIC_ 前缀）
```
