# E2E 测试指南

## 工具选择

### Playwright (推荐)

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
});
```

### Cypress

```javascript
// cypress.config.js
module.exports = {
  e2e: {
    baseUrl: 'http://localhost:3000',
    video: false,
    screenshotOnRunFailure: true,
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
};
```

## Playwright 基础

### 编写测试

```typescript
import { test, expect } from '@playwright/test';

test.describe('User Login', () => {
  test('should login successfully', async ({ page }) => {
    await page.goto('/login');
    
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'password123');
    await page.click('[type="submit"]');
    
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="user-name"]'))
      .toContainText('Test User');
  });

  test('should show error with invalid credentials', async ({ page }) => {
    await page.goto('/login');
    
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'wrongpassword');
    await page.click('[type="submit"]');
    
    await expect(page.locator('[data-testid="error"]')).toContainText('Invalid credentials');
  });
});
```

### 页面对象模式

```typescript
// pages/LoginPage.ts
import { type Page, type Locator } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.locator('[name="email"]');
    this.passwordInput = page.locator('[name="password"]');
    this.submitButton = page.locator('[type="submit"]');
    this.errorMessage = page.locator('[data-testid="error"]');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }
}

// 使用
import { test } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';

test('should login', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('test@example.com', 'password');
  
  await expect(page).toHaveURL('/dashboard');
});
```

## 常见场景

### 表单提交

```typescript
test('should submit contact form', async ({ page }) => {
  await page.goto('/contact');
  
  await page.fill('[name="name"]', 'John Doe');
  await page.fill('[name="email"]', 'john@example.com');
  await page.fill('[name="message"]', 'Hello, World!');
  
  await page.click('[type="submit"]');
  
  await expect(page.locator('.success-message')).toBeVisible();
  await expect(page.locator('.success-message')).toContainText('Thank you');
});
```

### 导航测试

```typescript
test('should navigate between pages', async ({ page }) => {
  await page.goto('/');
  
  await page.click('text=Products');
  await expect(page).toHaveURL('/products');
  
  await page.click('text=About');
  await expect(page).toHaveURL('/about');
});
```

### 模态框

```typescript
test('should open and close modal', async ({ page }) => {
  await page.goto('/dashboard');
  
  // 打开模态框
  await page.click('[data-testid="open-modal"]');
  await expect(page.locator('[data-testid="modal"]')).toBeVisible();
  
  // 关闭模态框
  await page.click('[data-testid="close-modal"]');
  await expect(page.locator('[data-testid="modal"]')).not.toBeVisible();
});
```

### 等待动态内容

```typescript
test('should wait for async data', async ({ page }) => {
  await page.goto('/users');
  
  // 等待数据加载
  await expect(page.locator('[data-testid="user-list"]')).toBeVisible();
  
  // 等待特定用户出现
  await expect(page.locator('text=John Doe')).toBeVisible();
  
  // 等待请求完成
  await page.waitForResponse((response) => 
    response.url().includes('/api/users') && response.status() === 200
  );
});
```

## 认证测试

```typescript
test.describe('Authenticated Flow', () => {
  test.use({ storageState: 'e2e/.auth/user.json' });
  
  test('should access protected route', async ({ page }) => {
    await page.goto('/dashboard');
    await expect(page.locator('[data-testid="welcome"]')).toContainText('Welcome');
  });
});

// 登录测试后保存状态
test('should login and save state', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'password');
  await page.click('[type="submit"]');
  
  await page.context().storageState({ path: 'e2e/.auth/user.json' });
});
```

## 断言技巧

```typescript
// 文本内容
await expect(locator).toContainText('Hello');
await expect(locator).toHaveText('Hello');

// 可见性
await expect(locator).toBeVisible();
await expect(locator).toBeHidden();

// 状态
await expect(locator).toBeChecked();
await expect(locator).toBeDisabled();
await expect(locator).toBeEnabled();

// URL
await expect(page).toHaveURL('/dashboard');
await expect(page).toHaveURL(/.*dashboard/);

// 计数
await expect(locator).toHaveCount(5);

// 自定义断言
await expect(locator).toHaveCSS('background-color', 'rgb(255, 0, 0)');
```

## CI/CD 集成

```yaml
# .github/workflows/e2e.yml
name: E2E Tests

on: [push, pull_request]

jobs:
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Start server
        run: npm run start &
      
      - name: Run E2E tests
        run: npx playwright test
      
      - name: Upload artifacts
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
```

## 测试最佳实践

### 1. 使用 data-testid

```typescript
// HTML
<button data-testid="submit-btn" class="btn-primary">Submit</button>

// 测试
await page.click('[data-testid="submit-btn"]');
```

### 2. 避免不必要的等待

```typescript
// ❌ 不好
await page.waitForTimeout(2000);

// ✅ 好
await expect(page.locator('[data-testid="success"]')).toBeVisible();
```

### 3. 隔离测试数据

```typescript
test('should create new item', async ({ page, request }) => {
  // 使用 API 创建测试数据
  const item = await request.post('/api/items', {
    data: { name: 'Test Item' }
  });
  
  // 测试 UI
  await page.goto('/items');
  await expect(page.locator('text=Test Item')).toBeVisible();
});
```

### 4. 并行执行

```typescript
// playwright.config.ts
export default defineConfig({
  fullyParallel: true,
  workers: process.env.CI ? 1 : 4,
});
```
