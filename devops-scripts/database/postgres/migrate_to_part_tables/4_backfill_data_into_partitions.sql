\o log/4_backfill_data_into_partitions.log
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2021-06-01' AND created_at < '2021-07-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2021-07-01' AND created_at < '2021-08-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2021-08-01' AND created_at < '2021-09-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2021-09-01' AND created_at < '2021-10-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2021-10-01' AND created_at < '2021-11-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2021-11-01' AND created_at < '2021-12-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2021-12-01' AND created_at < '2022-01-01';

INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-01-01' AND created_at < '2022-02-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-02-01' AND created_at < '2022-03-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-03-01' AND created_at < '2022-04-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-04-01' AND created_at < '2022-05-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-05-01' AND created_at < '2022-06-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-06-01' AND created_at < '2022-07-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-07-01' AND created_at < '2022-08-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-08-01' AND created_at < '2022-09-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-09-01' AND created_at < '2022-10-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-10-01' AND created_at < '2022-11-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-11-01' AND created_at < '2022-12-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2022-12-01' AND created_at < '2023-01-01';

INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-01-01' AND created_at < '2023-02-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-02-01' AND created_at < '2023-03-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-03-01' AND created_at < '2023-04-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-04-01' AND created_at < '2023-05-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-05-01' AND created_at < '2023-06-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-06-01' AND created_at < '2023-07-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-07-01' AND created_at < '2023-08-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-08-01' AND created_at < '2023-09-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-09-01' AND created_at < '2023-10-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-10-01' AND created_at < '2023-11-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-11-01' AND created_at < '2023-12-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2023-12-01' AND created_at < '2024-01-01';

INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-01-01' AND created_at < '2024-02-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-02-01' AND created_at < '2024-03-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-03-01' AND created_at < '2024-04-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-04-01' AND created_at < '2024-05-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-05-01' AND created_at < '2024-06-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-06-01' AND created_at < '2024-07-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-07-01' AND created_at < '2024-08-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-08-01' AND created_at < '2024-09-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-09-01' AND created_at < '2024-10-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-10-01' AND created_at < '2024-11-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-11-01' AND created_at < '2024-12-01';
INSERT INTO kcs_user_interactions_partitioned SELECT * FROM kcs_user_interactions WHERE created_at >= '2024-12-01' AND created_at < '2025-01-01';
\o
