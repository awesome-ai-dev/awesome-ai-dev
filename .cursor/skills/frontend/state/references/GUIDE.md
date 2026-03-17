# 状态管理指南

## 选择对比

| 库 | 特点 | 适用场景 |
|----|------|----------|
| Zustand | 轻量、简单 | 中小型项目 |
| Jotai | 原子化、组合 | 复杂状态 |
| Redux | 完整生态 | 大型项目 |
| Recoil | Facebook 出品 | React 专用 |
| TanStack Query | 服务端状态 | 数据获取 |

## Zustand 最佳实践

### Store 分离
```typescript
// stores/userStore.ts
export const useUserStore = create<UserState>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
}));

// stores/uiStore.ts  
export const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen })),
}));
```

### 持久化
```typescript
import { persist } from 'zustand/middleware';

export const useStore = create(
  persist(
    (set) => ({ count: 0 }),
    { name: 'my-store' }
  )
);
```

## TanStack Query 最佳实践

### 预获取
```typescript
const prefetchUser = async () => {
  await queryClient.prefetchQuery({
    queryKey: ['user', id],
    queryFn: () => fetchUser(id),
  });
};
```

### 乐观更新
```typescript
const mutation = useMutation({
  mutationFn: updateUser,
  onMutate: async (newUser) => {
    await queryClient.cancelQueries(['user', newUser.id]);
    const previousUser = queryClient.getQueryData(['user', newUser.id]);
    queryClient.setQueryData(['user', newUser.id], newUser);
    return { previousUser };
  },
});
```

## 性能优化

1. **选择器**: 只订阅需要的字段
```typescript
// ❌ 整 state 订阅
const { count } = useStore();

// ✅ 选择器
const count = useStore((state) => state.count);
```

2. **分离 Store**: 按功能模块化
3. **计算属性**: 用 computed 缓存

---
