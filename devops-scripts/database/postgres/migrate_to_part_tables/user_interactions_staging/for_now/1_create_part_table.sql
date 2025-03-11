\o log/1_create_part_table.log

CREATE TABLE IF NOT EXISTS public.user_interactions_part
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
    CONSTRAINT user_interactions_part_pkey PRIMARY KEY (id, created_at)
)
PARTITION BY RANGE (created_at);

-- GRANT ALL ON TABLE public.user_interactions_part TO nominis;
-- ALTER TABLE IF EXISTS public.user_interactions_part OWNER to nominis;
\o
