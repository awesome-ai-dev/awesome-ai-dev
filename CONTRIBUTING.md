# 贡献指南

欢迎贡献！本项目旨在帮助开发者更好地使用 AI 进行辅助开发，欢迎任何形式的贡献。

---

## 如何贡献

### 贡献方式

| 方式 | 说明 |
| ------ | ------ |
| 🐛 提交 Bug | 发现问题请提交 Issue |
| 💡 提出建议 | 有好想法请提交 Feature Request |
| 📝 补充内容 | 完善 Rules、Skills、Prompts |
| 🔧 修复代码 | 修复问题或优化代码 |
| 📖 完善文档 | 改进文档或添加翻译 |

### 贡献流程

```text
1. Fork 本项目
2. 创建分支 (git checkout -b feature/xxx)
3. 提交更改 (git commit -m 'add: xxx')
4. 推送分支 (git push origin feature/xxx)
5. 创建 Pull Request
```

---

## 贡献内容

### 可以贡献的内容

- **Rules** — 新的框架规范（如 Flutter、Svelte）
- **Skills** — 专业的技能（如 iOS 开发、区块链）
- **Agents** — 实用的代理（如 SEO 专家、数据分析师）
- **Prompts** — 场景提示词（如小程序开发、微信生态）
- **AI Tools** — 新的工具推荐

### 贡献规范

| 类型 | 规范 |
| ------ | ------ |
| Rules | 使用 `.mdc` 格式，包含 name、description、globs |
| Skills | 包含 SKILL.md，可选 scripts、references、assets |
| Agents | 使用 YAML 格式，包含 name、description、model |
| Prompts | 包含场景描述、输入格式、输出格式 |

### 内容要求

- ✅ 内容与现有文件不重复
- ✅ 包含实际可用的代码示例
- ✅ 有清晰的使用说明
- ✅ 使用中文编写

---

## 项目结构

```yaml
ai-summary/
├── .cursor/          # Cursor IDE 配置
│   ├── rules/        # 开发规范
│   ├── skills/       # 专业技能
│   └── agents/       # AI 助手
├── ai-tools/         # AI 工具推荐
├── prompts/          # 场景提示词
└── docs/             # 项目文档
```

---

## 提交规范

### 提交信息格式

```text
<type>(<scope>): <subject>

<body>
```

### Type 说明

| Type | 说明 |
| ------ | ------ |
| feat | 新功能 |
| fix | 修复 Bug |
| docs | 文档 |
| style | 格式 |
| refactor | 重构 |
| test | 测试 |
| chore | 构建/工具 |

### 示例

```text
feat(rules): 添加 Flutter 开发规范

添加 Flutter 3 开发规范，包含：
- Widget 最佳实践
- 状态管理方案
- 性能优化建议

Closes #123
```

---

## 问题反馈

### Bug 报告

请包含以下信息：

- **问题描述** — 清楚地描述问题
- **复现步骤** — 如何复现这个问题
- **预期行为** — 你期望的行为
- **截图** — 如果有的话
- **环境** — 操作系统、工具版本等

### 功能建议

请包含以下信息：

- **功能描述** — 你想要的功能
- **使用场景** — 什么情况下使用
- **替代方案** — 你考虑过的其他方案

---

## 联系方式

- GitHub Issues: https://github.com/[你的GitHub用户名]/awesome-ai-development/issues
- 提交 PR: https://github.com/[你的GitHub用户名]/awesome-ai-development/pulls

---

感谢你的贡献！ 🎉
