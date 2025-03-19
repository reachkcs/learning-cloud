SELECT 
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    pg_size_pretty(pg_indexes_size(relid)) AS indexes_size,
    n_live_tup AS row_count
FROM 
    pg_catalog.pg_stat_user_tables
ORDER BY 
    pg_total_relation_size(relid) DESC
LIMIT 10;

