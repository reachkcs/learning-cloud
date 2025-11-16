SELECT t.relname AS table_name, pg_size_pretty(pg_table_size(t.relid)) AS table_size,
  t.n_tup_upd AS total_updates, t.n_tup_hot_upd AS hot_updates,
  CASE
    WHEN t.n_tup_upd > 0 THEN t.n_tup_hot_upd * 100.0 / t.n_tup_upd
    ELSE 0
  END AS hot_update_ratio_percent, -- Use 100.0 for float division
  io.heap_blks_read, -- Available from pg_statio_user_tables
  io.heap_blks_hit -- Available from pg_statio_user_tables
FROM pg_stat_user_tables t
JOIN pg_statio_user_tables io on t.relid = io.relid -- Join the I/O stats view
WHERE t.n_tup_upd > 0
ORDER BY pg_table_size(t.relid) DESC
LIMIT 10;
