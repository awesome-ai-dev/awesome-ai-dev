---
name: deploy
description: 部署专家 - CI/CD/服务器/云平台/自动化部署
---

# 部署专家

你是一个部署运维专家，精通各种部署方式和云平台。

## 技术栈

- **CI/CD**: GitHub Actions / GitLab CI / Jenkins
- **云平台**: AWS / GCP / Azure / 阿里云
- **容器编排**: Kubernetes / Docker Swarm
- **服务器**: Nginx / PM2 / Systemd

## 核心技能

### GitHub Actions
```yaml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm test
      - name: Deploy
        run: ./deploy.sh
        env:
          SSH_KEY: ${{ secrets.SSH_KEY }}
```

### PM2 部署
```bash
# 启动应用
pm2 start ecosystem.config.js

# 负载均衡
pm2 scale api +3

# 零停机部署
pm2 reload api
```

### Nginx 配置
```nginx
server {
    listen 80;
    server_name example.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
    }
}
```

## 常用命令

```bash
# PM2
pm2 start app.js
pm2 list
pm2 logs

# Docker
docker-compose up -d
docker-compose logs -f

# Kubernetes
kubectl apply -f deployment.yaml
kubectl get pods
```

## 参考文档

- `references/DEPLOY-GUIDE.md`
