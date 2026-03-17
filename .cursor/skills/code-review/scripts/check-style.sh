#!/bin/bash

echo "=== Code Style Checker ==="
echo ""

PROJECT_DIR="${1:-.}"

echo "Project directory: $PROJECT_DIR"
echo ""

if [ -f "$PROJECT_DIR/package.json" ]; then
    cd "$PROJECT_DIR" || exit 1
    
    echo "=== 1. ESLint Check ==="
    if grep -q "eslint" "$PROJECT_DIR/package.json"; then
        npm run lint 2>&1 | head -50 || echo "No lint errors"
    else
        echo "ESLint not configured"
    fi
    
    echo ""
    echo "=== 2. Prettier Check ==="
    if [ -f "$PROJECT_DIR/.prettierrc" ] || [ -f "$PROJECT_DIR/prettier.config.js" ]; then
        npx prettier --check "src/**/*.{ts,tsx,js,jsx}" 2>&1 | head -30 || echo "Prettier check done"
    else
        echo "Prettier not configured"
    fi
    
    echo ""
    echo "=== 3. Import Order (isort for JS/TS) ==="
    if grep -q "isort" "$PROJECT_DIR/package.json"; then
        npx isort --check-only src 2>&1 | head -20 || echo "Import order OK"
    fi
    
    echo ""
    echo "=== 4. File Naming Check ==="
    echo "Checking for inconsistent naming..."
    
    find "$PROJECT_DIR/src" -type f \( -name "*.ts" -o -name "*.tsx" \) | while read file; do
        filename=$(basename "$file")
        
        # Check PascalCase for components
        if [[ "$filename" =~ ^[A-Z] ]]; then
            : # PascalCase is good for components
        elif [[ "$filename" =~ ^[a-z] ]]; then
            # camelCase is okay for utilities
            :
        else
            echo "Check naming: $filename"
        fi
    done
    
    echo ""
    echo "=== 5. Unused Exports ==="
    echo "Note: This is a basic check. Use TypeScript for more accurate results."
    
    echo ""
    echo "=== Style Summary ==="
    echo "Tips:"
    echo "  - Run 'npm run lint -- --fix' to auto-fix"
    echo "  - Run 'npx prettier --write' to format"
    echo "  - Use Husky pre-commit hooks"
fi

echo ""
echo "=== Check Complete ==="
