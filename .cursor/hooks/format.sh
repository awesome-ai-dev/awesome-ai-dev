#!/bin/bash

# =====================================================
# Cursor Hook: 文件保存后自动格式化
# 触发时机: afterFileEdit (文件编辑后)
# =====================================================

# 获取文件路径
FILE_PATH="$1"

# 只处理支持的文件类型
case "$FILE_PATH" in
  *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.md|*.mdx)
    echo "格式化文件: $FILE_PATH"
    npx prettier --write "$FILE_PATH" 2>/dev/null
    ;;
  *)
    echo "跳过格式化 (不支持的文件类型): $FILE_PATH"
    ;;
esac

# 输出 JSON 格式（Cursor Hook 协议要求）
echo '{"ok": true}'
