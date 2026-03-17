# Docker 构建脚本

#!/bin/bash

# 构建镜像
build() {
    echo "Building Docker image..."
    docker build -t app:latest .
}

# 运行容器
run() {
    echo "Running container..."
    docker run -d -p 3000:3000 --name app app:latest
}

# 停止容器
stop() {
    echo "Stopping container..."
    docker stop app
    docker rm app
}

# 查看日志
logs() {
    docker logs -f app
}

case "$1" in
    build) build ;;
    run) run ;;
    stop) stop ;;
    logs) logs ;;
    *) echo "Usage: $0 {build|run|stop|logs}" ;;
esac
