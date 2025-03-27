SELECT pid, usename, query, state, now() - query_start AS runtime
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY runtime DESC;

