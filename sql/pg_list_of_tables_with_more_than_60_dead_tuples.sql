SELECT schemaname, relname, n_dead_tup, last_autovacuum, last_autoanalyze FROM pg_stat_all_tables
WHERE schemaname like 'prod%' AND n_dead_tup > 25
ORDER BY n_dead_tup desc;
