SELECT
    query,
    calls,
    ROUND(total_time::NUMERIC, 2) AS total_exec_time,  -- Total execution time rounded to 2 decimals
    ROUND(mean_time::NUMERIC, 2) AS avg_exec_time,    -- Average execution time rounded to 2 decimals
    rows
FROM
    pg_stat_statements
ORDER BY
    total_time DESC
LIMIT 10;
