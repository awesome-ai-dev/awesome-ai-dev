#!/bin/bash

echo "=== Bundle Size Analyzer ==="
echo ""

PROJECT_DIR="${1:-.}"

echo "Project directory: $PROJECT_DIR"
echo ""

if [ -f "$PROJECT_DIR/package.json" ]; then
    echo "=== 1. Install dependencies ==="
    cd "$PROJECT_DIR" || exit 1
    
    if command -v npx &> /dev/null; then
        if [ -f "next.config.js" ] || [ -f "next.config.mjs" ]; then
            echo "=== Next.js Bundle Analysis ==="
            npx @next/bundle-analyzer 2>/dev/null || echo "Using alternative method..."
            
            echo ""
            echo "=== Checking with source-map-explorer ==="
            if npm ls source-map-explorer &> /dev/null; then
                npm run build 2>/dev/null
                npx source-map-explorer .next/static/**/*.js 2>/dev/null || echo "Run 'npm run build' first"
            fi
        fi
    fi
fi

echo ""
echo "=== 2. Check for large dependencies ==="
if [ -f "$PROJECT_DIR/package.json" ]; then
    echo "Largest dependencies by size:"
    cd "$PROJECT_DIR" && npm ls --depth=0 2>/dev/null | head -30
fi

echo ""
echo "=== 3. Analyze source files ==="
if [ -d "$PROJECT_DIR/src" ]; then
    echo "Top 20 largest source files:"
    find "$PROJECT_DIR/src" -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) -exec wc -l {} \; 2>/dev/null | sort -rn | head -20
fi

echo ""
echo "=== 4. Check for duplicate dependencies ==="
if [ -f "$PROJECT_DIR/package.json" ]; then
    cd "$PROJECT_DIR" && npm dedupe 2>/dev/null || echo "Run npm install first"
fi

echo ""
echo "=== Analysis Complete ==="
echo ""
echo "Tips:"
echo "  - Use dynamic imports for large components"
echo "  - Tree-shake unused code"
echo "  - Consider code splitting"
echo "  - Use lighter alternatives (e.g., dayjs instead of moment)"
