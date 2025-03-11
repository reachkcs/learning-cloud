\o log/10_if_required_partition_pruning.log
ALTER TABLE user_interactions DETACH PARTITION user_interactions_jun2021;
DROP TABLE user_interactions_jun2021;
\o
