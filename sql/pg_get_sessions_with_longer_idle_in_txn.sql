SELECT pid, usename, datname, client_addr, application_name, backend_start, xact_start, now() - xact_start AS duration, now() as current_tm, state, query
FROM pg_stat_activity WHERE state = 'idle in transaction' AND now() - xact_start > interval '30 minutes'
ORDER BY duration DESC;
