\prompt 'Enter username: ' username

SELECT datname, pid, query, state
FROM pg_stat_activity
WHERE usename = :'username';

