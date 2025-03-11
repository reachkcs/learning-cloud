\set ECHO queries
\o log/after.log
select now();
ANALYZE user_interactions_backup;
select now();
SELECT count(*) FROM user_interactions_backup;
select now();
EXPLAIN (VERBOSE, ANALYZE) SELECT count(*) FROM user_interactions_backup;
select now();
SELECT to_char(created_at, 'YYYY-MM'), count(*) FROM user_interactions_backup GROUP BY to_char(created_at, 'YYYY-MM') ORDER BY count(*) DESC;
select now();
EXPLAIN (VERBOSE, ANALYZE) SELECT to_char(created_at, 'YYYY-MM'), count(*) FROM user_interactions_backup GROUP BY to_char(created_at, 'YYYY-MM') ORDER BY count(*) DESC;
select now();
SELECT pg_size_pretty(pg_total_relation_size('user_interactions_backup')) AS total_size;
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'user_interactions_backup';
\o
\set ECHO none

