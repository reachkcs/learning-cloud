\o log/8_remove_trigger.log
DROP TRIGGER kcs_user_interactions_partitioned_trig ON kcs_user_interactions_backup;
DROP FUNCTION mig_kcs_user_interactions_func;
\o

