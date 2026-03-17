#!/bin/bash

# RAG 工具脚本

# 向量化文档
embed_docs() {
    local source_dir="$1"
    echo "Embedding documents from $source_dir..."
    python embed.py --source "$source_dir"
}

# 搜索相似文档
search() {
    local query="$1"
    echo "Searching: $query"
    python search.py --query "$query"
}

# 添加文档
add_doc() {
    local file="$1"
    echo "Adding document: $file"
    python add.py --file "$file"
}

# 删除索引
clear_index() {
    echo "Clearing vector index..."
    python clear.py
}

# 查看索引状态
status() {
    echo "Vector store status:"
    python status.py
}

case "$1" in
    embed) embed_docs "$2" ;;
    search) search "$2" ;;
    add) add_doc "$2" ;;
    clear) clear_index ;;
    status) status ;;
    *) echo "Usage: $0 {embed <dir>|search <query>|add <file>|clear|status}" ;;
esac
