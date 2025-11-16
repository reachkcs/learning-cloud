SELECT relid::regclass AS table_name,
	   n_live_tup AS live_tuples,
	   n_dead_tup AS dead_tuples,
	   ROUND(CASE WHEN n_live_tup > 0
	   			  THEN (n_dead_tup::numeric / (n_live_tup + n_dead_tup)) * 100
				  ELSE 0
			  END, 2) AS dead_ratio_percent,
	   last_autovacuum,
	   last_autoanalyze
FROM pg_stat_user_tables
WHERE n_live_tup > 1000 AND n_dead_tup > 0
ORDER BY dead_tuples DESC
LIMIT 10;
