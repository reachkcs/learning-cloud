#!/usr/bin/python3

from datetime import datetime, timedelta

def generate_partition_sql_with_index(start_month, start_year, partitioned_table_name):
    # Get the current date
    current_date = datetime.now()
    new_partitioned_table_name = f"{partitioned_table_name}_partitioned"
    
    # Start date
    start_date = datetime(start_year, start_month, 1)
    
    # Initialize the SQL script
    sql_script = ""
    
    # Generate partitions and indexes
    while start_date <= current_date:
        # Get the start and end dates for the partition
        end_date = start_date + timedelta(days=32)
        end_date = end_date.replace(day=1)  # Set to the first day of the next month
        
        # Partition name in MMMYYYY format
        partition_name = f"{partitioned_table_name}_{start_date.strftime('%b%Y').lower()}"
        
        # Generate SQL for the partition
        sql_script += f"""CREATE TABLE IF NOT EXISTS public.{partition_name} PARTITION OF {new_partitioned_table_name} FOR VALUES FROM ('{start_date.strftime('%Y-%m-%d')}') TO ('{end_date.strftime('%Y-%m-%d')}');\n"""
        
        # Generate SQL for the index
        sql_script += f"DROP INDEX IF EXISTS {partition_name}_user_profile_id_action_created_at;\n"
        sql_script += f"""CREATE INDEX IF NOT EXISTS {partition_name}_user_profile_id_action_created_at ON public.{partition_name} USING btree (user_profile_id ASC NULLS LAST, action COLLATE pg_catalog."default" ASC NULLS LAST, created_at ASC NULLS LAST);\n\n"""
        
        # Move to the next month
        start_date = end_date
    
    return sql_script

# Parameters for the script
start_month = 6  # June
start_year = 2021
partitioned_table_name = "kcs_user_interactions"

# Generate the SQL
sql_script = generate_partition_sql_with_index(start_month, start_year, partitioned_table_name)

# Write the SQL to a file
with open("2_create_partitions.sql", "w") as file:
    file.write(sql_script)

print("SQL script generated and saved to '2_create_partitions.sql'")

