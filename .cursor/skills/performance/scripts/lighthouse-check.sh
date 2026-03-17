#!/bin/bash

echo "=== Lighthouse Performance Check ==="
echo ""

URL="${1:-http://localhost:3000}"
OUTPUT_DIR="${2:-./lighthouse-results}"

mkdir -p "$OUTPUT_DIR"

echo "Target URL: $URL"
echo "Output directory: $OUTPUT_DIR"
echo ""

if command -v npx &> /dev/null; then
    echo "Running Lighthouse..."
    npx lighthouse "$URL" \
        --output=json,html \
        --output-path="$OUTPUT_DIR/report" \
        --only-categories=performance \
        --preset=desktop \
        --quiet
    
    if [ -f "$OUTPUT_DIR/report.json" ]; then
        echo ""
        echo "=== Performance Scores ==="
        cat "$OUTPUT_DIR/report.json" | grep -o '"categories":{[^}]*}' | jq -r '
            .categories.performance .score * 100 | floor | tostring + "%"
        ' 2>/dev/null || echo "Failed to parse scores"
        
        echo ""
        echo "=== Core Web Vitals ==="
        cat "$OUTPUT_DIR/report.json" | jq -r '
            .audits | to_entries[] | 
            select(.key | test("lcp|fid|cls|ttfb")) |
            "\(.key): \(.value.numericValue | floor) \(.value.unit)"
        ' 2>/dev/null || echo "Failed to parse Web Vitals"
        
        echo ""
        echo "Full report: $OUTPUT_DIR/report.html"
    fi
else
    echo "npx not found. Install Node.js first."
fi

echo ""
echo "=== Check Complete ==="
