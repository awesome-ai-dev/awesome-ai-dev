-- Query Optimization Analysis Template
-- 用于分析查询性能，识别 N+1 问题和不合理查询

-- 1. 查找最慢的查询
SELECT
    query,
    calls,
    mean_exec_time,
    total_exec_time,
    rows,
    (mean_exec_time * calls) as total_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- 2. 查找 N+1 查询模式（同一查询执行多次）
SELECT
    query,
    calls,
    mean_exec_time
FROM pg_stat_statements
WHERE calls > 10
ORDER BY calls DESC
LIMIT 10;

-- 3. 分析表的大小和行数
SELECT
    schemaname,
    relname,
    n_live_tup as row_count,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size,
    pg_size_pretty(pg_relation_size(relid)) as table_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) as index_size
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 20;

-- 4. 检查未使用的索引
SELECT
    schemaname,
    relname,
    indexrelname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY pg_relation_size(indexrelid) DESC;

-- 5. 检查重复索引
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE (schemaname, tablename, indexdef) IN (
    SELECT schemaname, tablename, indexdef
    FROM pg_indexes
    GROUP BY schemaname, tablename, indexdef
    HAVING COUNT(*) > 1
)
ORDER BY schemaname, tablename, indexname;

-- 6. 分析查询执行计划（模板）
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT your_query_here;

-- 7. 查找缺失的外键索引
SELECT
    tc.table_name,
    kcu.column_name,
    tc.constraint_name,
    tc.table_schema
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

-- 8. 检查缓存命中率
SELECT
    sum(heap_blks_read) as heap_read,
    sum(heap_blks_hit) as heap_hit,
    sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;

-- 9. 连接查询分析
SELECT
    relname,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch
FROM pg_stat_user_tables
WHERE seq_scan > 0
ORDER BY seq_scan DESC
LIMIT 10;
