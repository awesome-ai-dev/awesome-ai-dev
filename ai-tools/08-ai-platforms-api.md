# AI 平台 & API 基础设施

> 开发 AI 应用的基础设施和平台

## 大模型 API 提供商

### OpenAI
- **官网**：https://platform.openai.com
- **模型**：GPT-4o, GPT-4 Turbo, GPT-3.5, Whisper, DALL·E 3, TTS
- **核心能力**：
  - 最强通用能力
  - 函数调用（Function Calling）
  - JSON 模式
  - Vision 多模态
  - Assistants API（带状态对话）
  - 批量 API
- **价格**：按 token 计费，GPT-4o $5/1M input tokens
- **开发灵感**：任何需要高质量文本生成的应用

### Anthropic (Claude)
- **官网**：https://anthropic.com
- **模型**：Claude 3.5 Sonnet, Claude 3 Opus/Sonnet/Haiku
- **核心能力**：
  - 200K 超长上下文
  - 最强代码能力
  - Tool Use（工具调用）
  - Vision 图像理解
  - 宪法 AI（更安全）
- **价格**：Claude 3.5 Sonnet $3/1M input
- **开发灵感**：长文档处理、代码生成、安全敏感应用

### Google AI (Gemini)
- **官网**：https://ai.google.dev
- **模型**：Gemini 1.5 Pro/Flash, Gemma（开源）
- **核心能力**：
  - 100 万 token 上下文
  - 原生多模态
  - 视频理解
  - Google 搜索整合
- **价格**：Gemini 1.5 Flash 免费额度大
- **开发灵感**：视频分析、长文档、多模态应用

### Groq
- **官网**：https://groq.com
- **特点**：超快推理速度（LPU 芯片）
- **模型**：Llama 3, Mixtral, Gemma
- **核心能力**：
  - 500+ tokens/秒的推理速度
  - 低延迟
  - 开源模型托管
- **价格**：非常便宜，$0.05/1M tokens
- **开发灵感**：实时对话、低延迟应用

### Together AI
- **官网**：https://together.ai
- **特点**：开源模型云平台
- **模型**：Llama 3, Mixtral, CodeLlama, SDXL 等
- **核心能力**：
  - 100+ 开源模型
  - 模型微调
  - 推理优化
  - 专用部署
- **价格**：$0.2/1M tokens 起
- **开发灵感**：需要特定开源模型的应用

### Replicate
- **官网**：https://replicate.com
- **特点**：一键运行开源模型
- **核心能力**：
  - 海量开源模型
  - 图像/视频/音频模型
  - 简单的 API
  - 按秒计费
- **价格**：按 GPU 时间计费
- **开发灵感**：快速原型、多模型实验

### Fireworks AI
- **官网**：https://fireworks.ai
- **特点**：高性能推理
- **核心能力**：
  - 快速推理
  - 模型微调
  - 函数调用
  - 批量处理
- **价格**：$0.2/1M tokens 起
- **开发灵感**：性能敏感的生产应用

---

## 向量数据库 & RAG

### Pinecone
- **官网**：https://pinecone.io
- **定位**：托管向量数据库
- **核心能力**：
  - 完全托管
  - 实时更新
  - 元数据过滤
  - 混合搜索
  - Serverless 模式
- **价格**：免费版 + $70/月起
- **开发灵感**：知识库问答、语义搜索

### Weaviate
- **官网**：https://weaviate.io
- **定位**：开源向量数据库
- **核心能力**：
  - 开源可自部署
  - 内置向量化模块
  - GraphQL API
  - 混合搜索
- **价格**：开源免费 / 云版 $25/月起
- **开发灵感**：需要私有部署的 RAG

### Qdrant
- **官网**：https://qdrant.tech
- **定位**：高性能向量搜索
- **核心能力**：
  - Rust 开发，高性能
  - 开源自部署
  - 云托管选项
  - 丰富的过滤器
- **价格**：开源免费 / 云版按用量
- **开发灵感**：高性能推荐系统

### Chroma
- **官网**：https://trychroma.com
- **定位**：开发者友好的向量 DB
- **核心能力**：
  - 简单易用
  - 内嵌式数据库
  - Python/JS SDK
  - 与 LangChain 集成
- **价格**：开源免费
- **开发灵感**：快速原型、本地开发

### Milvus
- **官网**：https://milvus.io
- **定位**：企业级向量数据库
- **核心能力**：
  - 开源
  - 大规模支持
  - GPU 加速
  - 云原生
- **价格**：开源免费 / Zilliz Cloud 托管
- **开发灵感**：大规模向量搜索

---

## AI 开发框架

### LangChain
- **官网**：https://langchain.com
- **定位**：LLM 应用开发框架
- **核心能力**：
  - 链式调用
  - Agent 系统
  - RAG 工具
  - 多模型支持
  - LangSmith 调试
  - LangGraph 工作流
- **价格**：开源免费 / LangSmith $39/月
- **开发灵感**：复杂 AI 工作流、Agent

### LlamaIndex
- **官网**：https://llamaindex.ai
- **定位**：RAG 专用框架
- **核心能力**：
  - 数据连接器
  - 索引结构
  - 查询引擎
  - 多模态支持
- **价格**：开源免费 / Cloud 版付费
- **开发灵感**：知识库、文档问答

### Vercel AI SDK
- **官网**：https://sdk.vercel.ai
- **定位**：前端 AI 集成
- **核心能力**：
  - 流式 UI 组件
  - 多模型支持
  - React/Vue/Svelte
  - Edge Runtime
- **价格**：开源免费
- **开发灵感**：聊天应用、AI 功能集成

### Semantic Kernel
- **官网**：https://github.com/microsoft/semantic-kernel
- **定位**：微软 AI 编排框架
- **核心能力**：
  - C#/Python/Java
  - 企业级
  - Azure 集成
  - 插件系统
- **价格**：开源免费
- **开发灵感**：企业 AI 应用

### Haystack
- **官网**：https://haystack.deepset.ai
- **定位**：NLP/RAG 框架
- **核心能力**：
  - 模块化设计
  - 管道系统
  - 多种检索器
  - 生产就绪
- **价格**：开源免费
- **开发灵感**：搜索、问答系统

---

## 模型部署 & 微调

### Modal
- **官网**：https://modal.com
- **定位**：Serverless GPU 计算
- **核心能力**：
  - 按需 GPU
  - 简单的 Python 装饰器
  - 自动扩缩容
  - 快速冷启动
- **价格**：按秒计费
- **开发灵感**：模型推理、批量处理

### RunPod
- **官网**：https://runpod.io
- **定位**：GPU 云平台
- **核心能力**：
  - 低价 GPU
  - Serverless 端点
  - 模板市场
  - 社区模型
- **价格**：$0.20/小时起
- **开发灵感**：模型训练、推理服务

### Hugging Face
- **官网**：https://huggingface.co
- **定位**：AI 社区 & 平台
- **核心能力**：
  - 模型仓库
  - 数据集
  - Spaces 托管
  - Inference API
  - AutoTrain 微调
- **价格**：免费 + 付费 GPU
- **开发灵感**：模型探索、快速部署

### Anyscale
- **官网**：https://anyscale.com
- **定位**：Ray 云平台
- **核心能力**：
  - 分布式训练
  - 模型服务
  - 微调平台
  - 企业级
- **价格**：联系销售
- **开发灵感**：大规模 AI 应用

### Banana
- **官网**：https://banana.dev
- **定位**：ML 模型部署
- **核心能力**：
  - Serverless GPU
  - 简单部署
  - 自动扩缩
- **价格**：按秒计费
- **开发灵感**：模型 API 化

---

## AI Agent 平台

### AutoGPT
- **官网**：https://autogpt.net
- **定位**：自主 AI Agent
- **核心能力**：
  - 自主任务执行
  - 插件系统
  - 记忆管理
- **价格**：开源免费
- **开发灵感**：自动化 Agent

### CrewAI
- **官网**：https://crewai.com
- **定位**：多 Agent 协作
- **核心能力**：
  - 角色定义
  - 任务分配
  - Agent 协作
  - 工具集成
- **价格**：开源免费
- **开发灵感**：复杂任务的 Agent 系统

### SuperAGI
- **官网**：https://superagi.com
- **定位**：Agent 开发平台
- **核心能力**：
  - 可视化 Agent 构建
  - 工具市场
  - 并行执行
- **价格**：开源免费 / Cloud 付费
- **开发灵感**：Agent 平台

### Fixie
- **官网**：https://fixie.ai
- **定位**：对话 Agent 平台
- **核心能力**：
  - 自然语言构建 Agent
  - 工具集成
  - 企业部署
- **价格**：联系销售
- **开发灵感**：企业对话 Agent

---

## 提示词 & 评估

### PromptLayer
- **官网**：https://promptlayer.com
- **定位**：Prompt 管理平台
- **核心能力**：
  - Prompt 版本控制
  - A/B 测试
  - 分析监控
  - 团队协作
- **价格**：免费版 + Pro $25/月
- **开发灵感**：Prompt 管理 SaaS

### Weights & Biases
- **官网**：https://wandb.ai
- **定位**：MLOps 平台
- **核心能力**：
  - 实验追踪
  - 模型评估
  - 数据可视化
  - 团队协作
- **价格**：免费版 + 付费
- **开发灵感**：ML 实验管理

### Langfuse
- **官网**：https://langfuse.com
- **定位**：LLM 可观测性
- **核心能力**：
  - 开源可自部署
  - Trace 追踪
  - 评估指标
  - Prompt 管理
- **价格**：开源免费 / Cloud 付费
- **开发灵感**：LLM 监控工具

### Helicone
- **官网**：https://helicone.ai
- **定位**：LLM 监控
- **核心能力**：
  - 一行代码集成
  - 成本追踪
  - 请求日志
  - 速率限制
- **价格**：免费版 + Pro
- **开发灵感**：API 代理和监控
