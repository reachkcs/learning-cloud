\o log/0_pre_modify_table_uib.log

CREATE TABLE user_interactions_backup AS SELECT * FROM kcs_user_interactions;
CREATE SEQUENCE IF NOT EXISTS public.:table_name||_id_seq INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

SELECT MAX(id) FROM user_interactions_backup \gset
SELECT :max;
ALTER SEQUENCE user_interactions_backup_id_seq RESTART WITH :max;

ALTER SEQUENCE public.user_interactions_backup_id_seq OWNED BY public.user_interactions_backup.id;

ALTER SEQUENCE public.user_interactions_backup_id_seq OWNER TO aags;

ALTER TABLE IF NOT EXISTS user_interactions_backup ADD CONSTRAINT user_interactions_backup_pk PRIMARY KEY (id);

ALTER TABLE user_interactions_backup
ALTER COLUMN id SET DEFAULT nextval('user_interactions_backup_id_seq');

ALTER TABLE user_interactions_backup ALTER COLUMN created_at SET NOT NULL;
ALTER TABLE user_interactions_backup ALTER COLUMN updated_at SET NOT NULL;
GRANT ALL ON TABLE public.user_interactions_backup TO aags;

CREATE INDEX IF NOT EXISTS user_interactions_backup_user_profile_id_action_created_at
    ON public.user_interactions_backup USING btree
    (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST)
    TABLESPACE pg_default;
\o
