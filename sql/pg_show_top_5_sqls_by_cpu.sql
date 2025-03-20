SELECT query, calls, total_time, mean_time, max_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 5;
