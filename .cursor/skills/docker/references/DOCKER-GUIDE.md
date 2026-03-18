# Docker 最佳实践

## 镜像优化

### 1. 多阶段构建

- 减少最终镜像大小
- 分离构建和运行环境

### 2. 基础镜像选择

- 优先使用 Alpine
- 指定版本号

### 3. 层缓存优化

- 频繁变化的内容放后面
- COPY package*.json 先于 COPY 代码

### 4. .dockerignore

```text
node_modules
.git
*.md
.env
```text

## 安全加固

```dockerfile
# 非 root 用户
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

USER appuser
```text

## 健康检查

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```text

## 常用命令

```bash
# 构建
docker build -t myapp .

# 运行
docker run -d -p 3000:3000 myapp

# 查看日志
docker logs -f container_id

# 进入容器
docker exec -it container_id sh

# 清理
docker system prune -a
```text

## Docker Compose 技巧

```yaml
services:
  app:
    build: .
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3
```text

---
