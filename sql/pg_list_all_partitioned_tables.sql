SELECT c.relname AS partitioned_table,
       n.nspname AS schema_name,
       CASE p.partstrat
           WHEN 'r' THEN 'RANGE'
           WHEN 'l' THEN 'LIST'
           WHEN 'h' THEN 'HASH'
       END AS partition_strategy
FROM pg_partitioned_table p
JOIN pg_class c ON c.oid = p.partrelid
JOIN pg_namespace n ON c.relnamespace = n.oid
ORDER BY schema_name, partitioned_table;
