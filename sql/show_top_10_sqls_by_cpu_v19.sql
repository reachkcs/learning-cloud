SELECT
    query,
    calls,
    total_exec_time AS total_time,
    mean_exec_time AS avg_time,
    (total_exec_time / calls) AS time_per_call,
    rows
FROM
    pg_stat_statements
ORDER BY
    total_exec_time DESC
LIMIT 10;

