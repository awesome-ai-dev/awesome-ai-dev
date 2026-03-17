#!/bin/bash

echo "=== Mock Generator ==="
echo ""

PROJECT_DIR="${1:-.}"

echo "Project directory: $PROJECT_DIR"
echo ""

if [ -d "$PROJECT_DIR/src" ]; then
    echo "=== Generating mocks based on types ==="
    
    # Find TypeScript interfaces
    find "$PROJECT_DIR/src" -name "*.ts" -not -name "*.test.ts" | while read file; do
        echo "Analyzing: $file"
    done
    
    echo ""
    echo "=== MSW Service Worker Setup ==="
    if [ -f "$PROJECT_DIR/package.json" ]; then
        if grep -q "msw" "$PROJECT_DIR/package.json"; then
            echo "MSW found. Run 'npx msw init public --save' to initialize"
        else
            echo "Install MSW: npm install -D msw"
        fi
    fi
    
    echo ""
    echo "=== Vitest Mocks ==="
    cat << 'EOF'
# Vitest 常用 Mock 示例

# __mocks__/axios.ts
export default {
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
  delete: jest.fn(),
};

# 使用
import axios from 'axios';
jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;
EOF
fi

echo ""
echo "=== Generation Complete ==="
