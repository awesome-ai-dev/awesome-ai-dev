# Vue 3 开发规范 (Composition API)

## 项目结构

```
src/
├── components/
│   ├── ui/                 # 基础 UI 组件
│   │   ├── VButton.vue
│   │   └── VInput.vue
│   ├── forms/              # 表单组件
│   └── features/           # 业务组件
│       └── user/
├── composables/            # 组合式函数（相当于 React Hooks）
│   ├── useUser.ts
│   └── useDebounce.ts
├── stores/                 # Pinia 状态管理
│   └── user.ts
├── services/               # API 服务
│   └── user-service.ts
├── types/                  # TypeScript 类型
├── utils/                  # 工具函数
├── router/                 # 路由配置
├── views/                  # 页面组件
│   └── UserListView.vue
├── App.vue
└── main.ts
```

---

## 组件规范

### 单文件组件结构

```vue
<!-- UserCard.vue -->
<script setup lang="ts">
// 1. 导入
import { ref, computed, onMounted } from 'vue'
import type { User } from '@/types'

// 2. Props 定义
interface Props {
  user: User
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
})

// 3. Emits 定义
interface Emits {
  (e: 'edit', id: string): void
  (e: 'delete', id: string): void
}

const emit = defineEmits<Emits>()

// 4. 响应式状态
const isExpanded = ref(false)

// 5. 计算属性
const displayName = computed(() => {
  return `${props.user.firstName} ${props.user.lastName}`
})

// 6. 方法
function handleEdit() {
  emit('edit', props.user.id)
}

function handleDelete() {
  emit('delete', props.user.id)
}

// 7. 生命周期
onMounted(() => {
  console.log('UserCard mounted')
})
</script>

<template>
  <div class="user-card" :class="{ 'is-loading': loading }">
    <div class="user-card__header">
      <h3>{{ displayName }}</h3>
      <span>{{ user.email }}</span>
    </div>
    
    <div v-if="isExpanded" class="user-card__content">
      <p>{{ user.bio }}</p>
    </div>
    
    <div class="user-card__actions">
      <button @click="handleEdit">编辑</button>
      <button @click="handleDelete">删除</button>
      <button @click="isExpanded = !isExpanded">
        {{ isExpanded ? '收起' : '展开' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.user-card {
  padding: 1rem;
  border: 1px solid #e5e7eb;
  border-radius: 0.5rem;
}

.user-card.is-loading {
  opacity: 0.5;
}
</style>
```

### 命名规范

```typescript
// ✅ 组件文件名：PascalCase
UserProfile.vue
VButton.vue  // 基础组件加 V 前缀

// ✅ 组合式函数：use 前缀 + camelCase
useUser.ts
useDebounce.ts

// ✅ 视图/页面：View 后缀
UserListView.vue
SettingsView.vue
```

---

## Props & Emits

### Props 定义

```typescript
// ✅ 使用 TypeScript 接口定义
interface Props {
  // 必填属性
  title: string
  items: Item[]
  
  // 可选属性
  subtitle?: string
  loading?: boolean
  
  // 带默认值
  size?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
  subtitle: '',
  loading: false,
  size: 'md',
})

// ✅ 使用 props
console.log(props.title)
```

### Emits 定义

```typescript
// ✅ 类型安全的 emit
interface Emits {
  (e: 'update:modelValue', value: string): void
  (e: 'submit', data: FormData): void
  (e: 'cancel'): void
}

const emit = defineEmits<Emits>()

// 使用
emit('update:modelValue', 'new value')
emit('submit', formData)
```

### v-model 支持

```vue
<!-- 子组件 -->
<script setup lang="ts">
interface Props {
  modelValue: string
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

const value = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})
</script>

<template>
  <input v-model="value" />
</template>

<!-- 父组件使用 -->
<MyInput v-model="name" />
```

---

## 响应式系统

### ref vs reactive

```typescript
import { ref, reactive, toRefs } from 'vue'

// ✅ ref：基础类型 + 需要重新赋值的对象
const count = ref(0)
const user = ref<User | null>(null)

count.value++
user.value = await fetchUser()

// ✅ reactive：复杂对象结构
const state = reactive({
  users: [] as User[],
  loading: false,
  error: null as Error | null,
})

state.loading = true
state.users.push(newUser)

// ✅ toRefs：解构 reactive 保持响应性
const { users, loading } = toRefs(state)
```

### computed

```typescript
import { computed } from 'vue'

// ✅ 只读计算属性
const fullName = computed(() => {
  return `${firstName.value} ${lastName.value}`
})

// ✅ 可写计算属性
const fullName = computed({
  get: () => `${firstName.value} ${lastName.value}`,
  set: (val: string) => {
    const [first, last] = val.split(' ')
    firstName.value = first
    lastName.value = last
  },
})
```

### watch & watchEffect

```typescript
import { watch, watchEffect } from 'vue'

// ✅ watch：精确监听
watch(count, (newVal, oldVal) => {
  console.log(`count changed: ${oldVal} -> ${newVal}`)
})

// 监听多个源
watch([firstName, lastName], ([newFirst, newLast], [oldFirst, oldLast]) => {
  console.log('name changed')
})

// 深度监听
watch(
  () => state.user,
  (newUser) => {
    console.log('user changed', newUser)
  },
  { deep: true, immediate: true }
)

// ✅ watchEffect：自动追踪依赖
watchEffect(() => {
  console.log(`count is: ${count.value}`)
  // 自动追踪 count
})

// 带清理函数
watchEffect((onCleanup) => {
  const controller = new AbortController()
  fetchData(controller.signal)
  
  onCleanup(() => controller.abort())
})
```

---

## Composables（组合式函数）

### 基础结构

```typescript
// composables/useUser.ts
import { ref, computed, onMounted } from 'vue'
import type { User } from '@/types'
import { userService } from '@/services/user-service'

export function useUser(userId: string) {
  const user = ref<User | null>(null)
  const loading = ref(false)
  const error = ref<Error | null>(null)

  const displayName = computed(() => {
    return user.value ? `${user.value.firstName} ${user.value.lastName}` : ''
  })

  async function fetchUser() {
    loading.value = true
    error.value = null
    
    try {
      user.value = await userService.getUser(userId)
    } catch (e) {
      error.value = e as Error
    } finally {
      loading.value = false
    }
  }

  async function updateUser(data: Partial<User>) {
    loading.value = true
    try {
      user.value = await userService.updateUser(userId, data)
    } finally {
      loading.value = false
    }
  }

  onMounted(fetchUser)

  return {
    user,
    loading,
    error,
    displayName,
    fetchUser,
    updateUser,
  }
}

// 使用
const { user, loading, displayName } = useUser('123')
```

### 常用 Composables

```typescript
// useDebounce
export function useDebounce<T>(value: Ref<T>, delay = 300): Ref<T> {
  const debouncedValue = ref(value.value) as Ref<T>

  let timer: ReturnType<typeof setTimeout>
  
  watch(value, (newVal) => {
    clearTimeout(timer)
    timer = setTimeout(() => {
      debouncedValue.value = newVal
    }, delay)
  })

  return debouncedValue
}

// useLocalStorage
export function useLocalStorage<T>(key: string, defaultValue: T) {
  const data = ref<T>(defaultValue)

  // 初始化
  const stored = localStorage.getItem(key)
  if (stored) {
    data.value = JSON.parse(stored)
  }

  // 监听变化
  watch(
    data,
    (newVal) => {
      localStorage.setItem(key, JSON.stringify(newVal))
    },
    { deep: true }
  )

  return data
}

// useAsync
export function useAsync<T>(asyncFn: () => Promise<T>) {
  const data = ref<T | null>(null) as Ref<T | null>
  const loading = ref(false)
  const error = ref<Error | null>(null)

  async function execute() {
    loading.value = true
    error.value = null
    
    try {
      data.value = await asyncFn()
    } catch (e) {
      error.value = e as Error
    } finally {
      loading.value = false
    }
  }

  return { data, loading, error, execute }
}
```

---

## 状态管理 (Pinia)

### Store 定义

```typescript
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User } from '@/types'
import { userService } from '@/services/user-service'

// ✅ Setup Store 语法（推荐）
export const useUserStore = defineStore('user', () => {
  // State
  const user = ref<User | null>(null)
  const loading = ref(false)

  // Getters
  const isLoggedIn = computed(() => !!user.value)
  const displayName = computed(() => {
    return user.value ? `${user.value.firstName} ${user.value.lastName}` : ''
  })

  // Actions
  async function fetchUser() {
    loading.value = true
    try {
      user.value = await userService.getCurrentUser()
    } finally {
      loading.value = false
    }
  }

  async function login(credentials: { email: string; password: string }) {
    loading.value = true
    try {
      user.value = await userService.login(credentials)
    } finally {
      loading.value = false
    }
  }

  function logout() {
    user.value = null
  }

  return {
    user,
    loading,
    isLoggedIn,
    displayName,
    fetchUser,
    login,
    logout,
  }
}, {
  persist: true, // 持久化（需要 pinia-plugin-persistedstate）
})
```

### Store 使用

```vue
<script setup lang="ts">
import { useUserStore } from '@/stores/user'
import { storeToRefs } from 'pinia'

const userStore = useUserStore()

// ✅ 使用 storeToRefs 保持响应性
const { user, loading, isLoggedIn } = storeToRefs(userStore)

// Actions 直接解构
const { login, logout } = userStore
</script>
```

---

## 路由配置

```typescript
// router/index.ts
import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/HomeView.vue'),
  },
  {
    path: '/users',
    name: 'Users',
    component: () => import('@/views/UsersView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/users/:id',
    name: 'UserDetail',
    component: () => import('@/views/UserDetailView.vue'),
    props: true, // 将路由参数作为 props 传递
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFoundView.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// 导航守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  
  if (to.meta.requiresAuth && !userStore.isLoggedIn) {
    next({ name: 'Login', query: { redirect: to.fullPath } })
  } else {
    next()
  }
})

export default router
```

### 路由组合式 API

```vue
<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

// 获取参数
const userId = computed(() => route.params.id as string)
const page = computed(() => Number(route.query.page) || 1)

// 导航
function goToUser(id: string) {
  router.push({ name: 'UserDetail', params: { id } })
}

function goBack() {
  router.back()
}
</script>
```

---

## 表单处理 (VeeValidate + Zod)

```vue
<script setup lang="ts">
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import { z } from 'zod'

const schema = toTypedSchema(
  z.object({
    name: z.string().min(2, '至少 2 个字符'),
    email: z.string().email('请输入有效邮箱'),
    password: z.string().min(6, '至少 6 个字符'),
  })
)

const { handleSubmit, errors, isSubmitting, defineField } = useForm({
  validationSchema: schema,
})

const [name, nameAttrs] = defineField('name')
const [email, emailAttrs] = defineField('email')
const [password, passwordAttrs] = defineField('password')

const onSubmit = handleSubmit(async (values) => {
  try {
    await userService.register(values)
    // 成功处理
  } catch (error) {
    // 错误处理
  }
})
</script>

<template>
  <form @submit="onSubmit" class="space-y-4">
    <div>
      <input v-model="name" v-bind="nameAttrs" placeholder="用户名" />
      <span v-if="errors.name" class="text-red-500">{{ errors.name }}</span>
    </div>
    
    <div>
      <input v-model="email" v-bind="emailAttrs" type="email" placeholder="邮箱" />
      <span v-if="errors.email" class="text-red-500">{{ errors.email }}</span>
    </div>
    
    <div>
      <input v-model="password" v-bind="passwordAttrs" type="password" placeholder="密码" />
      <span v-if="errors.password" class="text-red-500">{{ errors.password }}</span>
    </div>
    
    <button type="submit" :disabled="isSubmitting">
      {{ isSubmitting ? '提交中...' : '注册' }}
    </button>
  </form>
</template>
```

---

## 异步组件 & Suspense

```vue
<!-- 父组件 -->
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const AsyncUserList = defineAsyncComponent({
  loader: () => import('./UserList.vue'),
  loadingComponent: LoadingSpinner,
  errorComponent: ErrorMessage,
  delay: 200,
  timeout: 10000,
})
</script>

<template>
  <Suspense>
    <template #default>
      <AsyncUserList />
    </template>
    <template #fallback>
      <LoadingSpinner />
    </template>
  </Suspense>
</template>
```

---

## Provide / Inject

```typescript
// 父组件
import { provide, ref } from 'vue'
import type { InjectionKey } from 'vue'

interface ThemeContext {
  theme: Ref<'light' | 'dark'>
  toggleTheme: () => void
}

export const ThemeKey: InjectionKey<ThemeContext> = Symbol('theme')

// 在父组件中
const theme = ref<'light' | 'dark'>('light')
const toggleTheme = () => {
  theme.value = theme.value === 'light' ? 'dark' : 'light'
}

provide(ThemeKey, { theme, toggleTheme })

// 子组件
import { inject } from 'vue'
import { ThemeKey } from './parent'

const themeContext = inject(ThemeKey)!
// 或提供默认值
const { theme, toggleTheme } = inject(ThemeKey, {
  theme: ref('light'),
  toggleTheme: () => {},
})
```

---

## 指令

### 自定义指令

```typescript
// directives/focus.ts
import type { Directive } from 'vue'

export const vFocus: Directive = {
  mounted(el: HTMLElement) {
    el.focus()
  },
}

// directives/click-outside.ts
export const vClickOutside: Directive = {
  mounted(el, binding) {
    el._clickOutside = (event: MouseEvent) => {
      if (!el.contains(event.target as Node)) {
        binding.value(event)
      }
    }
    document.addEventListener('click', el._clickOutside)
  },
  unmounted(el) {
    document.removeEventListener('click', el._clickOutside)
  },
}

// 全局注册
// main.ts
app.directive('focus', vFocus)
app.directive('click-outside', vClickOutside)

// 使用
<input v-focus />
<div v-click-outside="handleClickOutside">Dropdown</div>
```

---

## 测试规范

```typescript
// UserCard.test.ts
import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import UserCard from './UserCard.vue'

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
  }

  it('renders user name', () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser },
    })
    
    expect(wrapper.text()).toContain('John Doe')
  })

  it('emits edit event', async () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser },
    })
    
    await wrapper.find('[data-test="edit-btn"]').trigger('click')
    
    expect(wrapper.emitted('edit')).toBeTruthy()
    expect(wrapper.emitted('edit')![0]).toEqual(['1'])
  })

  it('shows loading state', () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser, loading: true },
    })
    
    expect(wrapper.classes()).toContain('is-loading')
  })
})

// Store 测试
import { setActivePinia, createPinia } from 'pinia'
import { useUserStore } from './user'

describe('User Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('logs in user', async () => {
    const store = useUserStore()
    
    await store.login({ email: 'test@test.com', password: 'password' })
    
    expect(store.isLoggedIn).toBe(true)
    expect(store.user).not.toBeNull()
  })
})
```

---

## 常见错误避免

```markdown
❌ 不要在 <script setup> 外部使用 Composition API
❌ 不要忘记 .value 访问 ref 值（在 JS 中）
❌ 不要直接解构 reactive 对象（会丢失响应性）
❌ 不要在模板中使用复杂表达式，应该用 computed
❌ 不要忘记清理 watch 和事件监听
❌ 不要在 Pinia action 中直接修改其他 store 的 state
❌ 不要在组件外部调用组合式函数
❌ 不要忘记给 v-for 添加 :key
❌ 不要使用 v-if 和 v-for 在同一元素上
```
