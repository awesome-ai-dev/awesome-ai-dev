---
name: ai-llm
description: LLM 应用开发 - OpenAI/Claude/提示词工程/Token 优化
---

# LLM 应用开发

## OpenAI

```typescript
import OpenAI from 'openai';

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// 基础调用
const completion = await openai.chat.completions.create({
  model: 'gpt-4o',
  messages: [
    { role: 'system', content: '你是一个助手' },
    { role: 'user', content: '你好' }
  ]
});

console.log(completion.choices[0].message.content);
```

## Claude

```typescript
import { Anthropic } from '@anthropic-ai/sdk';

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

const message = await anthropic.messages.create({
  model: 'claude-3-5-sonnet-20241022',
  max_tokens: 1024,
  messages: [
    { role: 'user', content: '你好' }
  ]
});
```

## 提示词工程

```typescript
// 结构化提示
const prompt = `
## 角色
你是一个专业的技术写作者。

## 任务
撰写技术文档。

## 要求
1. 简洁清晰
2. 包含代码示例
3. 中文输出

## 输出格式
markdown
`;

// Few-shot
const fewShotPrompt = `
例子：
输入：苹果
输出：水果

输入：BMW
输出：
`;
```

## Token 优化

```typescript
// 消息压缩
function compressMessages(messages: Message[]): Message[] {
  // 保留系统消息，压缩历史
  const system = messages[0];
  const recent = messages.slice(-6);
  return [system, ...recent];
}

// 流式输出
const stream = await openai.chat.completions.create({
  model: 'gpt-4o',
  messages: [{ role: 'user', content: '讲个故事' }],
  stream: true
});

for await (const chunk of stream) {
  process.stdout.write(chunk.choices[0]?.delta?.content || '');
}
```

## 最佳实践

1. 控制上下文长度
2. 流式输出体验好
3. 错误处理
4. 成本控制

## 参考

- `ai-tools/08-ai-platforms-api.md`
