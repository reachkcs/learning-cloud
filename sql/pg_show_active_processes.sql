SELECT pid, usename, application_name, state, query, now() - query_start AS runtime, 
       wait_event, backend_type 
FROM pg_stat_activity 
WHERE state = 'active'
ORDER BY runtime DESC;
