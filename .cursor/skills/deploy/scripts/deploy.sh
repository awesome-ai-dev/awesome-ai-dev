# Deploy 部署脚本

#!/bin/bash

# 部署
deploy() {
    echo "Deploying..."
    git pull origin main
    npm ci
    npm run build
    pm2 restart app
}

# 回滚
rollback() {
    echo "Rolling back..."
    git checkout $1
    npm ci
    npm run build
    pm2 restart app
}

# 状态
status() {
    pm2 list
    pm2 monit
}

# 日志
logs() {
    pm2 logs --lines 100
}

case "$1" in
    deploy) deploy ;;
    rollback) rollback $2 ;;
    status) status ;;
    logs) logs ;;
    *) echo "Usage: $0 {deploy|rollback|status|logs}" ;;
esac
