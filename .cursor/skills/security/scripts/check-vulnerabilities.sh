#!/bin/bash

echo "=== Security Vulnerability Scanner ==="
echo ""

PROJECT_DIR="${1:-.}"

echo "Project directory: $PROJECT_DIR"
echo ""

echo "=== 1. Checking for sensitive files in repository ==="
find "$PROJECT_DIR" -type f \( -name ".env*" -o -name "*.pem" -o -name "*.key" -o -name "credentials.json" \) 2>/dev/null | grep -v node_modules | grep -v ".git"

echo ""
echo "=== 2. Checking for hardcoded secrets (basic patterns) ==="
grep -r -E "(apiKey|apikey|secret|password|token)\s*[:=]\s*['\"][a-zA-Z0-9_-]{20,}['\"]" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" --include="*.java" 2>/dev/null | grep -v node_modules | head -20

echo ""
echo "=== 3. Checking SQL injection vulnerabilities ==="
grep -r -E "(query|execute|raw|sql)\s*\(" "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | grep -v node_modules | grep -v ".test." | head -10

echo ""
echo "=== 4. Checking for dangerous file operations ==="
grep -r -E "(exec|spawn|eval|system|shell_exec)\s*\(" "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | grep -v node_modules | head -10

echo ""
echo "=== 5. Checking authentication implementation ==="
grep -r -E "(jwt|JWT|bcrypt|argon2)" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | grep -v node_modules | head -10

echo ""
echo "=== 6. Checking for CORS misconfiguration ==="
grep -r -E "cors.*origin.*\*" "$PROJECT_DIR" --include="*.js" --include="*.ts" 2>/dev/null | grep -v node_modules | head -5

echo ""
echo "=== 7. Checking HTTPS usage ==="
grep -r "http://" "$PROJECT_DIR" --include="*.js" --include="*.ts" --include="*.html" 2>/dev/null | grep -v node_modules | grep -v "localhost" | head -5

echo ""
echo "=== Scan Complete ==="
echo "Note: This is a basic scanner. For comprehensive security testing, use dedicated tools like:"
echo "  - npm audit / yarn audit"
echo "  - snyk"
echo "  -OWASP ZAP"
echo "  - SonarQube"
