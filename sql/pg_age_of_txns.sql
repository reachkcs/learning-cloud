SELECT c.oid::regclass AS table_name,
  pg_table_size(c.oid) AS table_size,
  (SELECT setting::bigint FROM pg_settings WHERE name = 'autovacuum_freeze_max_age') AS freeze_max_age,
  age(c.relfrozenxid) AS xid_age_transactions,
  c.reloptions
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r' -- regular tables
  AND n.nspname NOT IN ('pg_catalog','information_schema')
ORDER BY xid_age_transactions DESC
LIMIT 10;
