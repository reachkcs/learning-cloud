SELECT
    query,
    calls,
    ROUND(shared_blks_read::NUMERIC, 2) AS shared_blks_read,
    ROUND(shared_blks_hit::NUMERIC, 2) AS shared_blks_hit,
    ROUND(local_blks_read::NUMERIC, 2) AS local_blks_read,
    ROUND(temp_blks_written::NUMERIC, 2) AS temp_blks_written,
    ROUND(blk_read_time::NUMERIC, 2) AS blk_read_time,
    ROUND(blk_write_time::NUMERIC, 2) AS blk_write_time
FROM
    pg_stat_statements
ORDER BY
    (shared_blks_read + local_blks_read + temp_blks_written) DESC
LIMIT 10;

