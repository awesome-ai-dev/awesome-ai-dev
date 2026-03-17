#!/bin/bash

# LLM 工具脚本

# OpenAI 调用示例
call_openai() {
    local prompt="$1"
    curl -s https://api.openai.com/v1/chat/completions \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -H "Content-Type: application/json" \
      -d "{
        \"model\": \"gpt-4o\",
        \"messages\": [{\"role\": \"user\", \"content\": \"$prompt\"}],
        \"temperature\": 0.7
      }"
}

# Claude 调用示例
call_claude() {
    local prompt="$1"
    curl -s https://api.anthropic.com/v1/messages \
      -H "x-api-key: $ANTHROPIC_API_KEY" \
      -H "anthropic-version: 2023-06-01" \
      -H "Content-Type: application/json" \
      -d "{
        \"model\": \"claude-3-5-sonnet-20241022\",
        \"max_tokens\": 1024,
        \"messages\": [{\"role\": \"user\", \"content\": \"$prompt\"}]
      }"
}

# 计算 Token
count_tokens() {
    local text="$1"
    # 简单估算: 中文 ≈ 1.5 tokens/字符, 英文 ≈ 1.25 tokens/词
    echo "约 $(echo "$text" | wc -c) 字符"
}

case "$1" in
    openai) call_openai "$2" ;;
    claude) call_claude "$2" ;;
    tokens) count_tokens "$2" ;;
    *) echo "Usage: $0 {openai <prompt>|claude <prompt>|tokens <text>}" ;;
esac
