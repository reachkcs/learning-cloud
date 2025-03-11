\o log/5_swap_table_names.log
BEGIN;
ALTER TABLE kcs_user_interactions RENAME TO kcs_user_interactions_backup;
ALTER TABLE kcs_user_interactions_partitioned RENAME TO kcs_user_interactions;
COMMIT;
\o
