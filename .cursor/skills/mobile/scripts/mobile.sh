# Mobile 构建脚本

#!/bin/bash

# 安装依赖
install() {
    npm install
}

# 开发模式
dev() {
    npx expo start
}

# iOS 构建
ios() {
    npx expo prebuild --platform ios
    cd ios && xcodebuild -workspace *.xcworkspace -scheme * -configuration Debug -destination "platform=iOS Simulator" build
}

# Android 构建
android() {
    npx expo prebuild --platform android
    cd android && ./gradlew assembleDebug
}

# 发布
build() {
    npx expo build
}

case "$1" in
    install) install ;;
    dev) dev ;;
    ios) ios ;;
    android) android ;;
    build) build ;;
    *) echo "Usage: $0 {install|dev|ios|android|build}" ;;
esac
