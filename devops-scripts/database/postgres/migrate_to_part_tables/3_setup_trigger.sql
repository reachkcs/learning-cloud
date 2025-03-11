\o log/3_setup_trigger.log
CREATE OR REPLACE FUNCTION mig_kcs_user_interactions_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO kcs_user_interactions_partitioned VALUES (NEW.*);
    RETURN NULL; -- Prevent insert into the old table
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER kcs_user_interactions_partitioned_trig
BEFORE INSERT ON kcs_user_interactions
FOR EACH ROW
EXECUTE FUNCTION mig_kcs_user_interactions_func();
\o
