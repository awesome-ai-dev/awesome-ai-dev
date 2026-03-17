#!/bin/bash

# ORM 工具脚本

# Prisma 生成
prisma_generate() {
    npx prisma generate
}

# Prisma 迁移
prisma_migrate() {
    local name="$1"
    npx prisma migrate dev --name "$name"
}

# Prisma 重置
prisma_reset() {
    npx prisma migrate reset --force
}

# Drizzle 生成
drizzle_generate() {
    npx drizzle-kit generate:sqlite
}

# 数据库推送
db_push() {
    npx prisma db push
}

# 客户端生成
db_client() {
    npx prisma generate
}

case "$1" in
    generate) prisma_generate ;;
    migrate) prisma_migrate "$2" ;;
    reset) prisma_reset ;;
    push) db_push ;;
    *) echo "Usage: $0 {generate|migrate <name>|reset|push}" ;;
esac
