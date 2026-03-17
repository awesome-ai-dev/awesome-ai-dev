---
name: frontend-ui
description: UI 组件库 - Radix/Tailwind CSS/Shadcn/Ant Design
---

# UI 组件库

## Radix UI (Headless)

```typescript
import * as Dialog from '@radix-ui/react-dialog';

function MyDialog() {
  return (
    <Dialog.Root>
      <Dialog.Trigger>打开</Dialog.Trigger>
      <Dialog.Portal>
        <Dialog.Overlay />
        <Dialog.Content>
          <Dialog.Title>标题</Dialog.Title>
          <Dialog.Close>关闭</Dialog.Close>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
```

## Shadcn UI

```bash
# 安装
npx shadcn@latest init
npx shadcn@latest add button dialog
```

```typescript
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogTrigger } from '@/components/ui/dialog';
```

## Tailwind CSS

```html
<div class="flex items-center justify-between p-4 bg-white rounded-lg shadow">
  <h1 class="text-xl font-bold text-gray-900">标题</h1>
  <button class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
    按钮
  </button>
</div>
```

## 选择指南
- **Shadcn**: 现代、定制性强
- **Ant Design**: 完整组件库
- **Radix**: Headless、无样式

## 参考
- `.cursor/rules/react.mdc`
