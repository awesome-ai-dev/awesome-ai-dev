---
name: frontend-css
description: CSS 框架 - Tailwind CSS/CSS Modules/Styled Components
---

# CSS 框架

## Tailwind CSS

### 基础用法
```html
<div class="flex flex-col gap-4 p-6 bg-gray-100 rounded-lg">
  <span class="text-sm text-gray-600">文本</span>
</div>
```

### 响应式
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <div>Item 1</div>
  <div>Item 2</div>
  <div>Item 3</div>
</div>
```

### 深色模式
```html
<div class="dark:bg-gray-900 dark:text-white">
  内容
</div>
```

## CSS Modules

```css
/* Button.module.css */
.button {
  background: blue;
  color: white;
}
```

```typescript
import styles from './Button.module.css';

<button className={styles.button}>按钮</button>
```

## Styled Components

```typescript
import styled from 'styled-components';

const Button = styled.button`
  background: blue;
  color: white;
  padding: 8px 16px;
  border-radius: 4px;
  
  &:hover {
    background: darkblue;
  }
`;
```

## 选择指南
- **Tailwind**: 快速开发、原子化
- **CSS Modules**: 原生、模块化
- **Styled Components**: CSS-in-JS、动态样式

## 参考
- `.cursor/rules/react.mdc`
