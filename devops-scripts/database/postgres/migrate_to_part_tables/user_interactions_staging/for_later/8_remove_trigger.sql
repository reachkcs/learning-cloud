\o log/8_remove_trigger.log
DROP TRIGGER user_interactions_backup_partitioned_trig ON user_interactions_backup_backup;
DROP FUNCTION mig_user_interactions_backup_func;
\o

