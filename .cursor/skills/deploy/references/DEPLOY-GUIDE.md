# 部署最佳实践

## 服务器配置

### Ubuntu 环境

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Node
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 安装 Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

### Nginx 配置

```nginx
upstream backend {
    server 127.0.0.1:3000;
}

server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static {
        alias /var/www/static;
        expires 30d;
    }
}
```

## 部署脚本

### 自动部署

```bash
#!/bin/bash

# 拉取代码
git pull origin main

# 安装依赖
npm ci

# 构建
npm run build

# 重启服务
pm2 restart app
pm2 save
```

### 回滚

```bash
pm2 delete all
git checkout v1.0.0
npm ci && npm run build
pm2 start ecosystem.config.js
```

## 监控

### PM2 监控

```bash
pm2 monit
pm2 list
pm2 logs --lines 100
```

### 系统监控

```bash
htop
df -h
free -h
```

---
