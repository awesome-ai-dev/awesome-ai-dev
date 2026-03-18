# RAG 系统指南

## 架构概览

```text
┌─────────────┐     ┌──────────────┐     ┌─────────┐
│   文档      │ ──▶ │  向量化      │ ──▶ │ 向量库  │
└─────────────┘     └──────────────┘     └─────────┘
                                                 │
┌─────────────┐     ┌──────────────┐            ▼
│   用户查询  │ ──▶ │  向量化      │ ◀── ┌─────────┐
└─────────────┘     └──────────────┘     │ LLM    │
                                          └─────────┘
```text

## 向量数据库选择

| 数据库 | 特点 | 适用场景 |
 |---:| --- |---:| 
| Pinecone | 云服务、易用 | 快速上线 |
| Weaviate | 开源、多模态 | 自托管 |
| Qdrant | Rust、高性能 | 大规模 |
| Milvus | 开源、分布式 | 超大规模 |
| Chroma | 轻量、嵌入 | 简单场景 |

## 文档处理

### 加载器

```typescript
import { PDFLoader } from 'langchain/document_loaders';
import { DocxLoader } from 'langchain/document_loaders';
import { CSVLoader } from 'langchain/document_loaders';
```text

### 分割策略

```typescript
// 通用分割
const splitter = new RecursiveCharacterTextSplitter({
  chunkSize: 1000,
  chunkOverlap: 200,
});

// Markdown 分割
const mdSplitter = new MarkdownTextSplitter({
  chunkSize: 500,
  overlap: 50
});

// 代码分割
const codeSplitter = new LanguageSplitter(
  LanguageSplitter.JavaScriptSplitter
);
```text

## 检索优化

### 1. Hybrid Search

```typescript
// 关键词 + 语义
const results = await hybridSearch(query, {
  keywordWeight: 0.3,
  semanticWeight: 0.7
});
```text

### 2. Re-ranking

```typescript
import { CohereRerank } from 'langchain/cohere-rerank';

const reranker = new CohereRerank();
const reranked = await reranker.rerank(results, query, { topK: 5 });
```text

### 3. 缓存

```typescript
const cache = new InMemoryCache();
const results = await cache.get(query) || await vectorStore.similaritySearch(query);
```text

## 最佳实践

1. **Chunk Size**: 500-1000 效果较好
2. **Overlap**: 20% 保持上下文
3. **Top K**: 3-5 条相关文档
4. **重排序**: 提升质量

---
