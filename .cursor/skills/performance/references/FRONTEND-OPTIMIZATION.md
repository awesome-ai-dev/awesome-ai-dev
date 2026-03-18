# 前端性能优化指南

## Core Web Vitals

### LCP (Largest Contentful Paint)

衡量主要内容加载时间。目标：< 2.5 秒

**优化策略：**

```typescript
// ✅ 使用 next/image 自动优化
import Image from 'next/image';

<Image 
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority // 优先加载 LCP 元素
/>

// ✅ 预连接关键资源
<head>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link
    rel="preconnect"
    href="https://fonts.gstatic.com"
    crossOrigin="anonymous"
  />
</head>

// ✅ 使用字体显示选项
<style>{`
  @import url('https://fonts.googleapis.com/css2?family=Inter&display=swap');
  font-display: swap;
`}</style>
```

### FID (First Input Delay)

衡量首次输入延迟。目标：< 100 毫秒

**优化策略：**

```typescript
// ✅ 减少 JavaScript 阻塞
// 拆分大型 JS
const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <Skeleton />
});

// ✅ 移除未使用的 JS
// next.config.js
module.exports = {
  experimental: {
    optimizePackageImports: ['lodash', 'moment'],
  },
};
```

### CLS (Cumulative Layout Shift)

衡量视觉稳定性。目标：< 0.1

**优化策略：**

```typescript
// ✅ 为图片和视频设置尺寸
<Image 
  src="/img.jpg"
  width={800}
  height={600}
  style={{ aspectRatio: '4/3' }}
/>

// ✅ 预留广告/动态内容空间
<div style={{ minHeight: '250px' }}>
  {/* 广告位 */}
</div>

// ✅ 使用 font-display: optional 或 block
<style>{`
  @font-face {
    font-family: 'MyFont';
    src: url('/my-font.woff2') format('woff2');
    font-display: optional;
  }
`}</style>
```

## 首屏加载优化

### 1. 代码分割

```typescript
// 动态导入
const Modal = dynamic(() => import('./Modal'));

const LazyComponent = dynamic(() => import('./LazyComponent'), {
  loading: () => <p>Loading...</p>,
  ssr: false, // 客户端-only
});
```

### 2. 服务端组件

```typescript
// app/page.tsx - Server Component (默认)
export default async function Page() {
  const data = await fetchData(); // 服务端执行
  return <MainContent data={data} />;
}

// components/Interactive.tsx - Client Component
'use client';
export function Interactive() {
  // 客户端交互
}
```

### 3. 缓存策略

```typescript
// next.config.js
module.exports = {
  images: {
    minimumCacheTTL: 60 * 60 * 24 * 30, // 30 days
  },
  async headers() {
    return [
      {
        source: '/static/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },
};
```

## React 性能优化

### 1. useMemo & useCallback

```typescript
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);

const memoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

### 2. React.memo

```typescript
const MemoizedComponent = React.memo(function Component({ data }) {
  return <div>{data}</div>;
});

// 自定义比较函数
const MemoizedWithComparison = React.memo(
  function Component({ data }) {
    return <div>{data}</div>;
  },
  (prevProps, nextProps) => {
    return prevProps.id === nextProps.id;
  }
);
```

### 3. 虚拟列表

```typescript
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualList({ items }) {
  const parentRef = useRef(null);
  
  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 35,
  });

  return (
    <div ref={parentRef} style={{ height: '400px', overflow: 'auto' }}>
      <div style={{ height: virtualizer.getTotalSize() }}>
        {virtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.key}
            style={{
              position: 'absolute',
              top: virtualRow.start,
              height: virtualRow.size,
            }}
          >
            {items[virtualRow.index].name}
          </div>
        ))}
      </div>
    </div>
  );
}
```

## 图片优化

### 1. 响应式图片

```typescript
<Image
  src="/img.jpg"
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  srcSet="
    /img-320.jpg 320w,
    /img-640.jpg 640w,
    /img-1200.jpg 1200w,
  "
  alt="Responsive image"
/>
```

### 2. 现代格式

```typescript
// 支持 WebP/AVIF
<Image
  src="/img.avif"
  fallback="/img.jpg" // 降级方案
  alt="Image"
/>
```

## 构建优化

### 1. Tree Shaking

```javascript
// 正确导入
import { cloneDeep, debounce } from 'lodash-es';

// 排除未使用的
module.exports = {
  optimizatio: {
    usedExports: true,
  },
};
```

### 2. 代码压缩

```javascript
// next.config.js
module.exports = {
  swcMinify: true,
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },
};
```
