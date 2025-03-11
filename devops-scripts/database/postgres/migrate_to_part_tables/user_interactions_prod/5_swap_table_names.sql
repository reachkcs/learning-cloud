\o log/5_swap_table_names.log
BEGIN;
ALTER TABLE user_interactions RENAME TO user_interactions_orig;
ALTER TABLE user_interactions_part RENAME TO user_interactions;
COMMIT;

SELECT MAX(id) FROM user_interactions;
\o
