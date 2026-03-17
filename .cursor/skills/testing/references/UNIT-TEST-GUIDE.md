# 单元测试指南

## 测试框架选择

### Vitest (推荐)

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        lines: 70,
        functions: 70,
        branches: 70,
        statements: 70,
      },
    },
  },
});
```

### Jest

```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/src/test/setup.ts'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/index.ts',
  ],
};
```

## AAA 模式

```typescript
describe('calculateTotal', () => {
  it('should calculate total with tax', () => {
    // Arrange - 准备测试数据
    const items = [
      { price: 100, quantity: 2 },
      { price: 50, quantity: 1 },
    ];
    const taxRate = 0.1;

    // Act - 执行被测函数
    const result = calculateTotal(items, taxRate);

    // Assert - 验证结果
    expect(result).toBe(275); // (100*2 + 50*1) * 1.1
  });
});
```

## Mock 技术

### 函数 Mock

```typescript
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { fetchUser } from './api';

describe('fetchUser', () => {
  beforeEach(() => {
    vi.mock('axios');
  });

  it('should fetch user successfully', async () => {
    const mockUser = { id: 1, name: 'John' };
    axios.get = vi.fn().mockResolvedValue({ data: mockUser });

    const user = await fetchUser(1);
    expect(user).toEqual(mockUser);
  });
});
```

### 模块 Mock

```typescript
// __mocks__/localStorage.ts
export default {
  getItem: vi.fn(),
  setItem: vi.fn(),
  removeItem: vi.fn(),
  clear: vi.fn(),
};

// 使用
import localStorage from 'localStorage';
vi.mock('localStorage');
```

### 定时器 Mock

```typescript
import { vi, it, expect, beforeEach, afterEach } from 'vitest';

beforeEach(() => {
  vi.useFakeTimers();
});

afterEach(() => {
  vi.useRealTimers();
});

it('should debounce', () => {
  const fn = vi.fn();
  const debounced = debounce(fn, 1000);

  debounced();
  debounced();
  debounced();

  expect(fn).not.toHaveBeenCalled();

  vi.advanceTimersByTime(1000);
  expect(fn).toHaveBeenCalledTimes(1);
});
```

## 常见场景测试

### 异步函数测试

```typescript
it('should handle async error', async () => {
  const error = new Error('Failed');
  
  vi.mocked(fetchData).mockRejectedValueOnce(error);
  
  await expect(fetchData()).rejects.toThrow('Failed');
});
```

### 模拟浏览器 API

```typescript
// Window resize
Object.defineProperty(window, 'innerWidth', { value: 1024 });
Object.defineProperty(window, 'innerHeight', { value: 768 });

// Fetch
global.fetch = vi.fn().mockResolvedValue({
  ok: true,
  json: () => Promise.resolve({ data: 'test' }),
});
```

### 测试组件 (React Testing Library)

```typescript
import { render, screen, fireEvent } from '@testing-library/react';

it('should render and handle click', () => {
  const onClick = vi.fn();
  
  render(<Button onClick={onClick}>Click me</Button>);
  
  const button = screen.getByRole('button', { name: /click me/i });
  fireEvent.click(button);
  
  expect(onClick).toHaveBeenCalledTimes(1);
});
```

## 测试最佳实践

### 1. 测试命名

```typescript
// ✅ 清晰描述测试场景
it('should return null when user is not authenticated');
it('should throw ValidationError when email is invalid');
it('should update user profile successfully');

// ❌ 模糊的测试名
it('works');
it('test1');
```

### 2. 测试结构

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data');
    it('should throw error with invalid email');
    it('should hash password before saving');
  });

  describe('getUser', () => {
    it('should return user by id');
    it('should return null for non-existent user');
  });
});
```

### 3. 避免过度 Mock

```typescript
// ✅ 好的测试 - Mock 外部依赖
it('should create user', async () => {
  vi.mocked(prisma.user.create).mockResolvedValue(mockUser);
  
  const user = await userService.create(validData);
  
  expect(user).toEqual(mockUser);
});

// ❌ 过度 Mock - 测试变得没有意义
it('should return mocked value', () => {
  const result = vi.fn(() => 'mocked');
  expect(result()).toBe('mocked');
});
```
