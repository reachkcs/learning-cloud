SELECT usename, count(*) AS active_sessions
FROM pg_stat_activity
WHERE state = 'active'
GROUP BY usename
ORDER BY active_sessions DESC;
