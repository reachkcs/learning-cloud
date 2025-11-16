WITH t AS (
  SELECT
    C.oid,
    nspname AS schema,
    relname AS table,
    pg_total_relation_size(C.oid) AS total_bytes,
    pg_relation_size(C.oid) AS table_bytes,
    COALESCE(NULLIF(C.reltuples,0),1) AS n_live_tup,
    COALESCE(NULLIF(C.relpages,0),1) AS relpages
  FROM pg_class C
  JOIN pg_namespace N ON N.oid = C.relnamespace
  WHERE relkind = 'r' AND nspname NOT IN ('pg_catalog','information_schema')
)
SELECT
  schema, table, total_bytes,
  round(total_bytes::numeric / (n_live_tup::numeric * 1),2) AS approx_bytes_per_tuple,
  -- crude estimate: if average tuple * live tuples << table size -> bloat exists
  (total_bytes - (n_live_tup * (total_bytes / NULLIF(relpages,0)) / 8)) AS crude_bloat_estimate_bytes
FROM t
ORDER BY total_bytes DESC
LIMIT 50;

