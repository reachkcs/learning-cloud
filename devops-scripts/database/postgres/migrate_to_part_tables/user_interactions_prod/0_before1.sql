\set ECHO queries
\o log/0_before1.log
select now();
select min(created_at), max(created_at) from user_interactions;
select now();
SELECT count(*) FROM user_interactions;
select now();
EXPLAIN (VERBOSE, ANALYZE) SELECT count(*) FROM user_interactions;
select now();
SELECT to_char(created_at, 'YYYY-MM'), count(*) FROM user_interactions GROUP BY to_char(created_at, 'YYYY-MM') ORDER BY 1 DESC;
select now();
EXPLAIN (VERBOSE, ANALYZE) SELECT to_char(created_at, 'YYYY-MM'), count(*) FROM user_interactions GROUP BY to_char(created_at, 'YYYY-MM') ORDER BY 1 DESC;
select now();
SELECT pg_size_pretty(pg_total_relation_size('user_interactions')) AS total_size;
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'user_interactions';
\o
\set ECHO none

