-- Table: public.user_interactions

-- DROP TABLE IF EXISTS public.user_interactions;

CREATE TABLE IF NOT EXISTS public.user_interactions
(
	    id bigint NOT NULL DEFAULT nextval('user_interactions_id_seq'::regclass),
	    user_id integer,
	    user_profile_id integer,
	    story_id integer,
	    action character varying COLLATE pg_catalog."default",
	    note jsonb,
	    created_at timestamp(6) without time zone NOT NULL,
	    updated_at timestamp(6) without time zone NOT NULL,
	    ipaddress character varying COLLATE pg_catalog."default",
	    activity_completion_id integer,
	    CONSTRAINT user_interactions_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.user_interactions
    OWNER to nominis;

REVOKE ALL ON TABLE public.user_interactions FROM avi_read_only;

GRANT SELECT ON TABLE public.user_interactions TO avi_read_only;

GRANT ALL ON TABLE public.user_interactions TO nominis;

GRANT ALL ON TABLE public.user_interactions TO sreedhar;

GRANT ALL ON TABLE public.user_interactions TO staging_adm;
-- Index: user_interactions_user_profile_id_action_created_at

-- DROP INDEX IF EXISTS public.user_interactions_user_profile_id_action_created_at;

CREATE INDEX IF NOT EXISTS user_interactions_user_profile_id_action_created_at
    ON public.user_interactions USING btree
    (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: user_interactions_part_trig

-- DROP TRIGGER IF EXISTS user_interactions_part_trig ON public.user_interactions;

CREATE OR REPLACE TRIGGER user_interactions_part_trig
    AFTER INSERT
    ON public.user_interactions
    FOR EACH ROW
	    EXECUTE FUNCTION public.mig_user_interactions_func();
