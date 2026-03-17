#!/bin/bash

echo "=== Database Index Checker ==="
echo ""

DB_URL="${DATABASE_URL:-postgresql://localhost:5432/dev}"

if [[ "$DB_URL" == postgresql://* ]]; then
    DB_NAME=$(echo $DB_URL | sed -E 's|.*/([^?]+).*|\1|')
    DB_HOST=$(echo $DB_URL | sed -E 's|postgresql://([^:]+):.*|\1|')

    echo "Checking indexes for database: $DB_NAME"
    echo ""

    echo "=== Tables and Indexes ==="
    psql "$DB_URL" -c "
        SELECT
            t.relname AS table_name,
            i.relname AS index_name,
            a.attname AS column_name,
            ix.indisunique AS is_unique
        FROM pg_class t
        JOIN pg_index ix ON t.oid = ix.indrelid
        JOIN pg_class i ON i.oid = ix.indexrelid
        JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(ix.indkey)
        WHERE t.relkind = 'r'
        ORDER BY t.relname, i.relname;
    "

    echo "=== Missing Indexes (Foreign Keys without indexes) ==="
    psql "$DB_URL" -c "
        SELECT
            tc.table_name,
            kcu.column_name,
            tc.constraint_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
            ON tc.constraint_name = kcu.constraint_name
            AND tc.table_schema = kcu.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
        AND NOT EXISTS (
            SELECT 1 FROM pg_indexes
            WHERE tablename = tc.table_name
            AND indexdef LIKE '%' || kcu.column_name || '%'
        )
        ORDER BY tc.table_name;
    "

    echo "=== Index Usage Statistics ==="
    psql "$DB_URL" -c "
        SELECT
            schemaname,
            relname,
            index_relname,
            idx_scan,
            idx_tup_read,
            idx_tup_fetch
        FROM pg_stat_user_indexes
        WHERE idx_scan = 0
        ORDER BY pg_relation_size(indexrelid) DESC
        LIMIT 10;
    "
fi

echo ""
echo "=== Check Complete ==="
