SELECT
  nspname AS schema,
  relname AS table,
  pg_size_pretty(pg_total_relation_size(C.oid)) AS total_size,
  pg_size_pretty(pg_relation_size(C.oid)) AS table_size,
  pg_size_pretty(pg_indexes_size(C.oid)) AS indexes_size,
  pg_total_relation_size(C.oid) AS total_size_bytes,
  pg_relation_size(C.oid) AS table_size_bytes
FROM pg_class C
JOIN pg_namespace N ON N.oid = C.relnamespace
WHERE relkind = 'r'
  AND nspname NOT IN ('pg_catalog','information_schema')
ORDER BY pg_total_relation_size(C.oid) DESC
LIMIT 50;

