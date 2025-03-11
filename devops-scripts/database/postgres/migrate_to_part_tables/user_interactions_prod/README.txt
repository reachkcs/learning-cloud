1. Make sure app changes are done to convert the primary key to be composite with id and created_at columns for user_interactions table
2. Run the below SQLs in the order as 'nominis' database user. Log files will be created in log folder.
    0_before1.sql
    0_before2.sql
    1_create_part_table.sql
    2_create_partitions.sql
    3_setup_trigger.sql
    4_backfill_data_into_partitions.sql
    5_swap_table_names.sql
    6_verify_data.sql
    7_remove_old_table.sql
    8_remove_trigger.sql
    9_analyze.sql
    11_after1.sql
    11_after2.sql

3. Create the function to create partition for next month by running create_next_month_partition_user_interactions_func.sql

4. Schedule a cron job with schedule '0 0 1 * *' to run the script create_next_month_partition_user_interactions_func.bash to run on 1st of every month.
