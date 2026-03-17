#!/bin/bash

echo "=== Test Coverage Checker ==="
echo ""

PROJECT_DIR="${1:-.}"

echo "Project directory: $PROJECT_DIR"
echo ""

if [ -f "$PROJECT_DIR/package.json" ]; then
    cd "$PROJECT_DIR" || exit 1
    
    echo "=== Running Coverage ==="
    
    if grep -q '"test"' "$PROJECT_DIR/package.json"; then
        if grep -q 'vitest' "$PROJECT_DIR/package.json"; then
            echo "Using Vitest..."
            npx vitest run --coverage 2>/dev/null || echo "Add coverage config to vitest.config.ts"
        elif grep -q 'jest' "$PROJECT_DIR/package.json"; then
            echo "Using Jest..."
            npx jest --coverage 2>/dev/null || echo "Add --coverage to test script"
        fi
    fi
    
    echo ""
    echo "=== Coverage Reports ==="
    
    if [ -d "$PROJECT_DIR/coverage" ]; then
        echo "Coverage directory found: $PROJECT_DIR/coverage"
        
        if [ -f "$PROJECT_DIR/coverage/index.html" ]; then
            echo "Open $PROJECT_DIR/coverage/index.html to view detailed report"
        fi
        
        echo ""
        echo "Summary:"
        if [ -f "$PROJECT_DIR/coverage/coverage-summary.json" ]; then
            cat "$PROJECT_DIR/coverage/coverage-summary.json" | jq -r '
                . | to_entries[] |
                "\(.key): " +
                (if .value.pct_covered != null then (.value.pct_covered | tostring) + "%" 
                else (.value | to_entries[] | "\(.key): \(.value | tostring)%") end)
            ' 2>/dev/null || echo "Failed to parse summary"
        fi
    fi
    
    echo ""
    echo "=== Coverage Thresholds ==="
    echo "Recommended thresholds:"
    echo "  - Statements: 70%"
    echo "  - Branches: 70%"
    echo "  - Functions: 70%"
    echo "  - Lines: 70%"
    echo "  - Uncovered files should not increase"
fi

echo ""
echo "=== Check Complete ==="
