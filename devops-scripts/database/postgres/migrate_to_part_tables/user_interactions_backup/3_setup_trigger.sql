\o log/3_setup_trigger.log
CREATE OR REPLACE FUNCTION mig_user_interactions_backup_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_interactions_backup_partitioned VALUES (NEW.*);
    RETURN NULL; -- Prevent insert into the old table
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_interactions_backup_partitioned_trig
BEFORE INSERT ON user_interactions_backup
FOR EACH ROW
EXECUTE FUNCTION mig_user_interactions_backup_func();
\o
