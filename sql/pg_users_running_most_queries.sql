-- Does not work if pg_stat_statements extention is not enabled
SELECT usename, sum(xact_commit + xact_rollback) AS total_queries
FROM pg_stat_database
GROUP BY usename
ORDER BY total_queries DESC;

