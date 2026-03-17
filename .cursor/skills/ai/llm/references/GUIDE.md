# LLM 应用指南

## 模型选择

| 模型 | 特点 | 适用场景 |
|------|------|----------|
| GPT-4o | 全面、多模态 | 通用任务 |
| o1 | 推理能力强 | 复杂推理 |
| Claude 3.5 | 长文本、分析 | 文档分析 |
| Gemini | 多模态、免费 | 图像/视频 |

## 提示词技巧

### System Prompt
```typescript
const systemPrompt = `
## 角色
你是一个专业的技术顾问。

## 背景
用户是一家 SaaS 公司的 CTO。

## 目标
帮助用户优化技术架构。

## 约束
- 使用中文
- 保持专业但易懂
`;
```

### Few-shot
```typescript
const prompt = `
判断情感:

正面: 这个产品太棒了！
负面: 体验很差，失望

正面: 服务态度很好
`;
```

## 成本优化

### Token 估算
- 中文: ~1.5 tokens/字符
- 英文: ~0.75 tokens/词

### 成本计算
```typescript
const cost = (inputTokens * 0.0015 + outputTokens * 0.015);
```

### 优化策略
1. 精简 system prompt
2. 压缩历史消息
3. 使用 streaming
4. 缓存重复请求

## 错误处理

```typescript
async function callLLM(prompt: string, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      return await openai.chat.completions.create({
        model: 'gpt-4o',
        messages: [{ role: 'user', content: prompt }]
      });
    } catch (e) {
      if (e.status === 429) { // rate limit
        await sleep(1000 * (i + 1));
      } else {
        throw e;
      }
    }
  }
}
```

## 最佳实践
1. 结构化输出用 JSON mode
2. 敏感信息不传入 prompt
3. 合理设置 temperature
4. 监控 token 消耗

---
