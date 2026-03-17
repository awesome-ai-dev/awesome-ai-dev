#!/bin/bash

# =====================================================
# Cursor Hook: 代码安全检查
# 触发时机: beforeSubmitPrompt (提交前)
# 用途: 在 AI 生成代码前检查是否包含敏感信息
# =====================================================

# 读取 stdin 输入 (JSON 格式)
INPUT=$(cat stdin)

# 检查是否包含敏感关键词
SECRET_PATTERNS=("apiKey" "apikey" "secret" "password" "token" "private_key")

for pattern in "${SECRET_PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qi "$pattern.*=.*['\"][a-zA-Z0-9_-]\{15,\}"; then
    echo "⚠️ 警告: 检测到可能包含敏感信息的提示词: $pattern"
    echo "请确保不要在提示词中包含实际的密钥或密码"
  fi
done

# 检查是否包含危险操作
DANGEROUS_PATTERNS=("DROP TABLE" "DELETE FROM" "TRUNCATE" "rm -rf")

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qi "$pattern"; then
    echo "⚠️ 警告: 检测到危险操作: $pattern"
  fi
done

# 输出 JSON 格式（Cursor Hook 协议要求）
# ok: true 允许继续, ok: false 阻止操作
echo '{"ok": true}'
