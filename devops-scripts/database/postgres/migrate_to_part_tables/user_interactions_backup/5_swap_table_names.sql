\o log/5_swap_table_names.log
BEGIN;
ALTER TABLE user_interactions_backup RENAME TO user_interactions_backup_backup;
ALTER TABLE user_interactions_backup_partitioned RENAME TO user_interactions_backup;
COMMIT;
\o
