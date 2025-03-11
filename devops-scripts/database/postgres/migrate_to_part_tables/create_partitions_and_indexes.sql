CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jun2021 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2021-06-01') TO ('2021-07-01');
DROP INDEX IF EXISTS kcs_user_interactions_jun2021_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jun2021_user_profile_id_action_created_at ON public.kcs_user_interactions_jun2021 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jul2021 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2021-07-01') TO ('2021-08-01');
DROP INDEX IF EXISTS kcs_user_interactions_jul2021_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jul2021_user_profile_id_action_created_at ON public.kcs_user_interactions_jul2021 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_aug2021 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2021-08-01') TO ('2021-09-01');
DROP INDEX IF EXISTS kcs_user_interactions_aug2021_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_aug2021_user_profile_id_action_created_at ON public.kcs_user_interactions_aug2021 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_sep2021 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2021-09-01') TO ('2021-10-01');
DROP INDEX IF EXISTS kcs_user_interactions_sep2021_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_sep2021_user_profile_id_action_created_at ON public.kcs_user_interactions_sep2021 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_oct2021 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2021-10-01') TO ('2021-11-01');
DROP INDEX IF EXISTS kcs_user_interactions_oct2021_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_oct2021_user_profile_id_action_created_at ON public.kcs_user_interactions_oct2021 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_nov2021 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2021-11-01') TO ('2021-12-01');
DROP INDEX IF EXISTS kcs_user_interactions_nov2021_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_nov2021_user_profile_id_action_created_at ON public.kcs_user_interactions_nov2021 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_dec2021 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2021-12-01') TO ('2022-01-01');
DROP INDEX IF EXISTS kcs_user_interactions_dec2021_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_dec2021_user_profile_id_action_created_at ON public.kcs_user_interactions_dec2021 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jan2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-01-01') TO ('2022-02-01');
DROP INDEX IF EXISTS kcs_user_interactions_jan2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jan2022_user_profile_id_action_created_at ON public.kcs_user_interactions_jan2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_feb2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-02-01') TO ('2022-03-01');
DROP INDEX IF EXISTS kcs_user_interactions_feb2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_feb2022_user_profile_id_action_created_at ON public.kcs_user_interactions_feb2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_mar2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-03-01') TO ('2022-04-01');
DROP INDEX IF EXISTS kcs_user_interactions_mar2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_mar2022_user_profile_id_action_created_at ON public.kcs_user_interactions_mar2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_apr2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-04-01') TO ('2022-05-01');
DROP INDEX IF EXISTS kcs_user_interactions_apr2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_apr2022_user_profile_id_action_created_at ON public.kcs_user_interactions_apr2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_may2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-05-01') TO ('2022-06-01');
DROP INDEX IF EXISTS kcs_user_interactions_may2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_may2022_user_profile_id_action_created_at ON public.kcs_user_interactions_may2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jun2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-06-01') TO ('2022-07-01');
DROP INDEX IF EXISTS kcs_user_interactions_jun2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jun2022_user_profile_id_action_created_at ON public.kcs_user_interactions_jun2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jul2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-07-01') TO ('2022-08-01');
DROP INDEX IF EXISTS kcs_user_interactions_jul2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jul2022_user_profile_id_action_created_at ON public.kcs_user_interactions_jul2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_aug2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-08-01') TO ('2022-09-01');
DROP INDEX IF EXISTS kcs_user_interactions_aug2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_aug2022_user_profile_id_action_created_at ON public.kcs_user_interactions_aug2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_sep2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-09-01') TO ('2022-10-01');
DROP INDEX IF EXISTS kcs_user_interactions_sep2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_sep2022_user_profile_id_action_created_at ON public.kcs_user_interactions_sep2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_oct2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-10-01') TO ('2022-11-01');
DROP INDEX IF EXISTS kcs_user_interactions_oct2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_oct2022_user_profile_id_action_created_at ON public.kcs_user_interactions_oct2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_nov2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-11-01') TO ('2022-12-01');
DROP INDEX IF EXISTS kcs_user_interactions_nov2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_nov2022_user_profile_id_action_created_at ON public.kcs_user_interactions_nov2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_dec2022 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2022-12-01') TO ('2023-01-01');
DROP INDEX IF EXISTS kcs_user_interactions_dec2022_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_dec2022_user_profile_id_action_created_at ON public.kcs_user_interactions_dec2022 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jan2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');
DROP INDEX IF EXISTS kcs_user_interactions_jan2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jan2023_user_profile_id_action_created_at ON public.kcs_user_interactions_jan2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_feb2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');
DROP INDEX IF EXISTS kcs_user_interactions_feb2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_feb2023_user_profile_id_action_created_at ON public.kcs_user_interactions_feb2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_mar2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-03-01') TO ('2023-04-01');
DROP INDEX IF EXISTS kcs_user_interactions_mar2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_mar2023_user_profile_id_action_created_at ON public.kcs_user_interactions_mar2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_apr2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-04-01') TO ('2023-05-01');
DROP INDEX IF EXISTS kcs_user_interactions_apr2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_apr2023_user_profile_id_action_created_at ON public.kcs_user_interactions_apr2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_may2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-05-01') TO ('2023-06-01');
DROP INDEX IF EXISTS kcs_user_interactions_may2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_may2023_user_profile_id_action_created_at ON public.kcs_user_interactions_may2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jun2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-06-01') TO ('2023-07-01');
DROP INDEX IF EXISTS kcs_user_interactions_jun2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jun2023_user_profile_id_action_created_at ON public.kcs_user_interactions_jun2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jul2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-07-01') TO ('2023-08-01');
DROP INDEX IF EXISTS kcs_user_interactions_jul2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jul2023_user_profile_id_action_created_at ON public.kcs_user_interactions_jul2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_aug2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-08-01') TO ('2023-09-01');
DROP INDEX IF EXISTS kcs_user_interactions_aug2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_aug2023_user_profile_id_action_created_at ON public.kcs_user_interactions_aug2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_sep2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-09-01') TO ('2023-10-01');
DROP INDEX IF EXISTS kcs_user_interactions_sep2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_sep2023_user_profile_id_action_created_at ON public.kcs_user_interactions_sep2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_oct2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-10-01') TO ('2023-11-01');
DROP INDEX IF EXISTS kcs_user_interactions_oct2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_oct2023_user_profile_id_action_created_at ON public.kcs_user_interactions_oct2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_nov2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-11-01') TO ('2023-12-01');
DROP INDEX IF EXISTS kcs_user_interactions_nov2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_nov2023_user_profile_id_action_created_at ON public.kcs_user_interactions_nov2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_dec2023 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2023-12-01') TO ('2024-01-01');
DROP INDEX IF EXISTS kcs_user_interactions_dec2023_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_dec2023_user_profile_id_action_created_at ON public.kcs_user_interactions_dec2023 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jan2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
DROP INDEX IF EXISTS kcs_user_interactions_jan2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jan2024_user_profile_id_action_created_at ON public.kcs_user_interactions_jan2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_feb2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
DROP INDEX IF EXISTS kcs_user_interactions_feb2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_feb2024_user_profile_id_action_created_at ON public.kcs_user_interactions_feb2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_mar2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');
DROP INDEX IF EXISTS kcs_user_interactions_mar2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_mar2024_user_profile_id_action_created_at ON public.kcs_user_interactions_mar2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_apr2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');
DROP INDEX IF EXISTS kcs_user_interactions_apr2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_apr2024_user_profile_id_action_created_at ON public.kcs_user_interactions_apr2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_may2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-05-01') TO ('2024-06-01');
DROP INDEX IF EXISTS kcs_user_interactions_may2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_may2024_user_profile_id_action_created_at ON public.kcs_user_interactions_may2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jun2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');
DROP INDEX IF EXISTS kcs_user_interactions_jun2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jun2024_user_profile_id_action_created_at ON public.kcs_user_interactions_jun2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_jul2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-07-01') TO ('2024-08-01');
DROP INDEX IF EXISTS kcs_user_interactions_jul2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_jul2024_user_profile_id_action_created_at ON public.kcs_user_interactions_jul2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_aug2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-08-01') TO ('2024-09-01');
DROP INDEX IF EXISTS kcs_user_interactions_aug2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_aug2024_user_profile_id_action_created_at ON public.kcs_user_interactions_aug2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_sep2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-09-01') TO ('2024-10-01');
DROP INDEX IF EXISTS kcs_user_interactions_sep2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_sep2024_user_profile_id_action_created_at ON public.kcs_user_interactions_sep2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_oct2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-10-01') TO ('2024-11-01');
DROP INDEX IF EXISTS kcs_user_interactions_oct2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_oct2024_user_profile_id_action_created_at ON public.kcs_user_interactions_oct2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.kcs_user_interactions_nov2024 PARTITION OF kcs_user_interactions_partitioned FOR VALUES FROM ('2024-11-01') TO ('2024-12-01');
DROP INDEX IF EXISTS kcs_user_interactions_nov2024_user_profile_id_action_created_at
CREATE INDEX IF NOT EXISTS kcs_user_interactions_nov2024_user_profile_id_action_created_at ON public.kcs_user_interactions_nov2024 USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);

