\o log/10_if_required_partition_pruning.log
ALTER TABLE kcs_user_interactions DETACH PARTITION kcs_user_interactions_jun2021;
DROP TABLE kcs_user_interactions_jun2021;
\o
