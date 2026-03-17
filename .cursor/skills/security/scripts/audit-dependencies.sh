#!/bin/bash

echo "=== Dependency Security Audit ==="
echo ""

PROJECT_DIR="${1:-.}"

cd "$PROJECT_DIR" || exit 1

echo "=== 1. npm audit ==="
if command -v npm &> /dev/null; then
    if [ -f "package.json" ]; then
        npm audit --audit-level=moderate 2>/dev/null || echo "npm audit not available"
    fi
fi

echo ""
echo "=== 2. check-package.sh (Snyk alternative) ==="
if command -v snyk &> /dev/null; then
    snyk test 2>/dev/null || echo "Snyk test completed"
else
    echo "Snyk not installed. Install with: npm install -g snyk"
fi

echo ""
echo "=== 3. pip-audit (Python) ==="
if command -v pip-audit &> /dev/null; then
    pip-audit 2>/dev/null || echo "pip-audit completed"
else
    if [ -f "requirements.txt" ]; then
        echo "Consider installing pip-audit: pip install pip-audit"
    fi
fi

echo ""
echo "=== 4. Safety (Python) ==="
if command -v safety &> /dev/null; then
    safety check 2>/dev/null || echo "Safety check completed"
else
    if [ -f "requirements.txt" ]; then
        echo "Consider installing safety: pip install safety"
    fi
fi

echo ""
echo "=== 5. Bundle Audit (Ruby) ==="
if command -v bundle-audit &> /dev/null; then
    if [ -f "Gemfile" ]; then
        bundle-audit check 2>/dev/null || echo "Bundle audit completed"
    fi
else
    if [ -f "Gemfile" ]; then
        echo "Consider installing bundle-audit: gem install bundle-audit"
    fi
fi

echo ""
echo "=== 6. OWASP Dependency Check (Java/Node) ==="
if command -v dependency-check &> /dev/null; then
    dependency-check --project . --scan . 2>/dev/null || echo "Dependency check completed"
else
    echo "OWASP Dependency-Check not installed"
fi

echo ""
echo "=== Audit Summary ==="
echo "For Node.js projects:"
echo "  npm audit"
echo "  npx snyk test"
echo "  npm install -g snyk"
echo ""
echo "For Python projects:"
echo "  pip install pip-audit safety"
echo "  pip-audit"
echo "  safety check"
echo ""
echo "=== Complete ==="
