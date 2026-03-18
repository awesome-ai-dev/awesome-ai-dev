---
name: ai-rag
description: RAG 系统 - LangChain/Vectara/向量数据库/文档分割
---

# RAG 系统

## 架构

```text
用户问题 → 检索 → 向量库 → 相关文档 → LLM → 回答
```

## LangChain

```typescript
import { LangChain } from 'langchain';
import { OpenAIEmbeddings } from 'langchain/embeddings';
import { PineconeVectorStore } from 'langchain/vectorstores';

// 文档加载
import { PDFLoader } from 'langchain/document_loaders';
const loader = new PDFLoader('document.pdf');
const docs = await loader.load();

// 分割
import { RecursiveCharacterTextSplitter } from 'langchain/text_splitter';
const splitter = new RecursiveCharacterTextSplitter({
  chunkSize: 1000,
  chunkOverlap: 200
});
const splitDocs = await splitter.splitDocuments(docs);

// 向量化
const embeddings = new OpenAIEmbeddings();
const vectors = await embeddings.embedDocuments(
  splitDocs.map(d => d.pageContent)
);

// 存储到向量库
const store = new PineconeVectorStore(embeddings, { pineconeIndex });
await store.addDocuments(splitDocs);

// 检索
const retriever = store.asRetriever();
const results = await retriever.getRelevantDocuments('问题');
```

## 文档分割策略

```typescript
// 按标题分割
import { MarkdownTextSplitter } from 'langchain/text_splitter';
const splitter = new MarkdownTextSplitter({
  chunkSize: 1000,
  chunkOverlap: 200,
  stripHeaders: true
});

// 按代码块分割
const codeSplitter = new RecursiveCharacterTextSplitter({
  chunkSize: 500,
  chunkOverlap: 50,
  separators: ['\n\n', '\n', '```', ' ']
});
```

## 检索优化

```typescript
// MMR (最大边际相关)
const retriever = vectorStore.asRetriever({
  searchType: 'mmr',
  searchArgs: {
    k: 5,
    fetchK: 20,
    lambda: 0.5
  }
});

// 混合搜索
const fusionRetriever = new FusionRetriever([keywordRetriever, semanticRetriever]);
```

## 最佳实践

1. 合理选择 chunk size
2. 混合搜索效果更好
3. 重排序提升质量
4. 成本与效果平衡

## 参考

- `ai-tools/08-ai-platforms-api.md`
