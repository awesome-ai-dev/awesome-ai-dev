# 状态管理脚本

#!/bin/bash

# 安装 Zustand
npm install zustand

# 安装 Jotai
npm install jotai

# 安装 TanStack Query
npm install @tanstack/react-query

# 生成 store 模板
generate_store() {
    cat > stores/$1.ts << 'EOF'
import { create } from 'zustand';

interface Store {
  // state
}

export const useStore = create<Store>((set) => ({
  // actions
}));
EOF
}

case "$1" in
    install) echo "Installing state management libs..." ;;
    store) generate_store "$2" ;;
    *) echo "Usage: $0 {install|store <name>}" ;;
esac
