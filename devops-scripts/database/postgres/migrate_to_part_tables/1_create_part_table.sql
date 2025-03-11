\o log/1_create_part_table.log
DROP TABLE public.kcs_user_interactions_partitioned;
CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_partitioned
(
    id bigint NOT NULL DEFAULT nextval('kcs_user_interactions_id_seq'::regclass),
    user_id integer,
    user_profile_id integer,
    story_id integer,
    action character varying COLLATE pg_catalog."default",
    note jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    ipaddress character varying COLLATE pg_catalog."default",
    activity_completion_id integer,
    CONSTRAINT kcs_user_interactions_part_pkey PRIMARY KEY (id, created_at)
)
PARTITION BY RANGE (created_at);

ALTER TABLE IF EXISTS public.kcs_user_interactions_partitioned OWNER to aags;
GRANT ALL ON TABLE public.kcs_user_interactions_partitioned TO aags;
\o
