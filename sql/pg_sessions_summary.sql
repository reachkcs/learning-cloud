SELECT usename AS username, COUNT(*)
FROM pg_stat_activity
GROUP BY usename;

