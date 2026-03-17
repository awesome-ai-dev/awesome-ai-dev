#!/bin/bash

echo "=== Auto Code Review ==="
echo ""

PROJECT_DIR="${1:-.}"

echo "Project directory: $PROJECT_DIR"
echo ""

echo "=== 1. Running ESLint ==="
if [ -f "$PROJECT_DIR/package.json" ]; then
    cd "$PROJECT_DIR" || exit 1
    
    if grep -q '"lint"' "$PROJECT_DIR/package.json"; then
        npm run lint 2>/dev/null || echo "Lint check completed"
    else
        if command -v npx &> /dev/null; then
            npx eslint src --ext .ts,.tsx,.js,.jsx 2>/dev/null || echo "No ESLint config found"
        fi
    fi
fi

echo ""
echo "=== 2. Running TypeScript Check ==="
if [ -f "$PROJECT_DIR/tsconfig.json" ]; then
    npx tsc --noEmit 2>/dev/null || echo "TypeScript check completed"
fi

echo ""
echo "=== 3. Checking for common issues ==="

echo "--- Hardcoded secrets ---"
grep -r -n -E "(apiKey|apikey|secret|password|token)\s*[:=]\s*['\"][a-zA-Z0-9_-]{15,}['\"]" "$PROJECT_DIR/src" --include="*.ts" --include="*.tsx" 2>/dev/null | head -10 || echo "No hardcoded secrets found"

echo ""
echo "--- Console.log statements ---"
grep -r -n "console.log" "$PROJECT_DIR/src" --include="*.ts" --include="*.tsx" 2>/dev/null | head -10 || echo "No console.log found"

echo ""
echo "--- TODO comments ---"
grep -r -n "TODO\|FIXME\|HACK" "$PROJECT_DIR/src" --include="*.ts" --include="*.tsx" 2>/dev/null | head -10 || echo "No TODO found"

echo ""
echo "--- Unused variables ---"
grep -r -n "^\s*const\s\+[a-z]\+.*=\s*[^=];$" "$PROJECT_DIR/src" --include="*.ts" --include="*.tsx" -E 2>/dev/null | head -10 || echo "No obvious unused variables"

echo ""
echo "=== 4. Complexity Check ==="
find "$PROJECT_DIR/src" -name "*.ts" -o -name "*.tsx" | while read file; do
    lines=$(wc -l < "$file")
    if [ "$lines" -gt 300 ]; then
        echo "Large file: $file ($lines lines)"
    fi
done

echo ""
echo "=== 5. Import Analysis ==="
echo "Checking for circular dependencies..."
if command -v npx &> /dev/null; then
    npx madge --circular "$PROJECT_DIR/src" 2>/dev/null || echo "madge not installed"
fi

echo ""
echo "=== Review Complete ==="
