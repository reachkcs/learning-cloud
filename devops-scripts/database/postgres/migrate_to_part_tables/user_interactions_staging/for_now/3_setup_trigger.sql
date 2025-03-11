\o log/3_setup_trigger.log
CREATE OR REPLACE FUNCTION mig_user_interactions_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_interactions_part(id, user_id, user_profile_id, story_id, action, note, created_at, updated_at, ipaddress, activity_completion_id)
VALUES (NEW.id, NEW.user_id, NEW.user_profile_id, NEW.story_id, NEW.action, NEW.note, NEW.created_at, NEW.updated_at, NEW.ipaddress, NEW.activity_completion_id);

    RETURN NEW; -- Makes sure that the insert into the old table occurs
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_interactions_part_trig
AFTER INSERT ON user_interactions
FOR EACH ROW
EXECUTE FUNCTION mig_user_interactions_func();
\o
