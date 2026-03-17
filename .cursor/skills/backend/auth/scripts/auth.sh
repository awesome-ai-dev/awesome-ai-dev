#!/bin/bash

# JWT 工具

# 生成密钥
generate_secret() {
    openssl rand -base64 32
}

# 生成 Token
generate_token() {
    local payload="$1"
    local secret="$2"
    # 使用 node 生成
    node -e "
    const jwt = require('jsonwebtoken');
    const token = jwt.sign($payload, '$secret', { expiresIn: '7d' });
    console.log(token);
    "
}

# 验证 Token
verify_token() {
    local token="$1"
    local secret="$2"
    node -e "
    const jwt = require('jsonwebtoken');
    try {
      const decoded = jwt.verify('$token', '$secret');
      console.log(JSON.stringify(decoded));
    } catch (e) {
      console.error('Invalid token');
    }
    "
}

case "$1" in
    secret) generate_secret ;;
    token) generate_token "$2" "$3" ;;
    verify) verify_token "$2" "$3" ;;
    *) echo "Usage: $0 {secret|token <payload> <secret>|verify <token> <secret>}" ;;
esac
