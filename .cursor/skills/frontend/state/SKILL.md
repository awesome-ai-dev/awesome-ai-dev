---
name: frontend-state
description: 前端状态管理 - Zustand/Jotai/Redux/TanStack Query
---

# 前端状态管理

## Zustand

```typescript
import { create } from 'zustand';

interface CounterStore {
  count: number;
  inc: () => void;
}

const useStore = create<CounterStore>((set) => ({
  count: 0,
  inc: () => set((state) => ({ count: state.count + 1 })),
}));

function Counter() {
  const { count, inc } = useStore();
  return <button onClick={inc}>{count}</button>;
}
```

## Jotai

```typescript
import { atom } from 'jotai';
import { useAtom } from 'jotai';

const countAtom = atom(0);

function Counter() {
  const [count, setCount] = useAtom(countAtom);
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>;
}
```

## TanStack Query

```typescript
import { useQuery, useMutation } from '@tanstack/react-query';

function UserList() {
  const { data, isLoading } = useQuery({
    queryKey: ['users'],
    queryFn: () => fetch('/api/users').then(r => r.json())
  });
  
  if (isLoading) return <Loading />;
  return <List data={data} />;
}
```

## 选择指南

- **Zustand**: 简单、轻量
- **Jotai**: 原子化、适合复杂状态
- **TanStack Query**: 服务端状态、缓存

## 参考

- `.cursor/rules/react.mdc`
