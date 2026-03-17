---
name: ai-agent
description: AI Agent - OpenAI Agents SDK/LangChain Agents/工具调用/记忆机制
---

# AI Agent 开发

## OpenAI Agents SDK

```typescript
import { Agent, tool } from '@openai/agents';

@tool
async function searchWeb(query: string) {
  // 搜索工具
  return `搜索结果: ${query}`;
}

@tool  
async function calculate(expr: string) {
  // 计算工具
  return eval(expr).toString();
}

const agent = Agent({
  name: 'assistant',
  instructions: '你是一个有帮助的助手',
  tools: [searchWeb, calculate]
});

const result = await agent.run('搜索今天的新闻，然后计算 2+2');
```

## LangChain Agents

```typescript
import { createOpenAIFunctionsAgent } from 'langchain/agents';
import { ChatOpenAI } from 'langchain/chat_models';
import { SerpAPI } from 'langchain/tools';
import { Calculator } from 'langchain/tools/calculator';

const tools = [new SerpAPI(), new Calculator()];

const agent = await createOpenAIFunctionsAgent({
  llm: new ChatOpenAI({ model: 'gpt-4o' }),
  tools
});

const result = await agent.invoke({
  input: '搜索 AI 新闻并计算 10+5'
});
```

## 工具定义

```typescript
// 自定义工具
import { tool } from 'langchain/core/tools';

const getWeather = tool(
  async ({ city }: { city: string }) => {
    // 调用天气 API
    return `城市 ${city} 天气晴朗，25度`;
  },
  {
    name: 'get_weather',
    description: '获取城市天气信息',
    schema: z.object({
      city: z.string().describe('城市名称')
    })
  }
);
```

## 记忆机制

```typescript
import { BufferMemory } from 'langchain/memory';

const memory = new BufferMemory({
  returnMessages: true,
  memoryKey: 'chat_history'
});

// 存储对话
await memory.saveContext(
  { input: '我叫张三' },
  { output: '你好张三，很高兴认识你' }
);

// 读取历史
const history = await memory.loadMemoryVariables({});
```

## Agent 模式

| 模式 | 说明 |
|------|------|
| ReAct | 推理 + 行动 |
| Plan-and-Execute | 计划后执行 |
| Tool Use | 工具调用 |
| Self-Reflection | 自我反思 |

## 最佳实践

1. 工具设计要清晰
2. 错误处理要完善
3. 避免无限循环
4. 合理使用记忆

## 参考

- `ai-tools/08-ai-platforms-api.md`
