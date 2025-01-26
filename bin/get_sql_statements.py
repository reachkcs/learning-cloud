#!/usr/bin/python3

import boto3
import argparse
from datetime import datetime
import os

def fetch_db_instance_resource_id(rds_client, db_instance_identifier):
    """Fetch the Resource ID of the DB instance."""
    try:
        response = rds_client.describe_db_instances(
            DBInstanceIdentifier=db_instance_identifier
        )
        # Extract the Resource ID
        return response['DBInstances'][0]['DbiResourceId']
    except Exception as e:
        print(f"Error fetching DB instance Resource ID: {e}")
        return None

def fetch_sql_statements(pi_client, db_resource_id, start_time, end_time):
    """Fetch SQL statements using Performance Insights."""
    try:
        pi_response = pi_client.describe_dimension_keys(
            ServiceType='RDS',
            Identifier=db_resource_id,
            Metric='db.load.avg',
            GroupBy={'Group': 'db.sql'},
            StartTime=start_time,
            EndTime=end_time
        )

        sql_statements = pi_response.get('Keys', [])
        return sql_statements
    except Exception as e:
        print(f"Error fetching SQL statements: {e}")
        return None

def get_full_sql_stmt(pi_client, sql_id, db_resource_id, start_time, end_time, truncated_sql):
    full_sql_response = pi_client.get_resource_metrics(
        ServiceType='RDS',
        Identifier=db_resource_id,
        MetricQueries=[{'Metric': 'db.load.avg'}],
        StartTime=start_time,
        EndTime=end_time
    )
    full_sql = full_sql_response.get('Metrics', [{}])[0].get('Value', truncated_sql)
    return full_sql

def main():
    # Command-line argument parsing
    parser = argparse.ArgumentParser(description="Fetch SQL statements from Aurora using Performance Insights.")
    parser.add_argument('db_instance_identifier', type=str, help="Aurora DB Instance Identifier")
    parser.add_argument('start_time', type=str, help="Start time in ISO 8601 format (e.g., 2024-12-02T19:30:00-05:00)")
    parser.add_argument('end_time', type=str, help="End time in ISO 8601 format (e.g., 2024-12-02T20:30:00-05:00)")
    
    args = parser.parse_args()
    db_instance_identifier = args.db_instance_identifier
    start_time_str = args.start_time
    end_time_str = args.end_time

    aws_region = os.getenv('AWS_REGION')
    if not aws_region:
        print("Please define AWS_REGION environment variable and retry")
        sys.exit()

    # Convert string times to datetime objects
    try:
        start_time = datetime.fromisoformat(start_time_str)
        end_time = datetime.fromisoformat(end_time_str)
    except ValueError as e:
        print(f"Invalid time format: {e}")
        return

    # Initialize clients
    rds_client = boto3.client('rds', region_name=aws_region)
    pi_client = boto3.client('pi', region_name=aws_region)

    # Fetch the DB instance ARN
    db_resource_id = fetch_db_instance_resource_id(rds_client, db_instance_identifier)
    if not db_resource_id:
        return
    print(f"DB Resource Id: {db_resource_id}")

    # Fetch SQL statements
    sql_statements = fetch_sql_statements(pi_client, db_resource_id, start_time, end_time)
    if not sql_statements:
        print("No SQL statements found for the specified time range.")
        return

    # Display SQL statements
    print(f"SQL Statements from {start_time_str} to {end_time_str} for DB Instance '{db_instance_identifier}':")
    for key in sql_statements:
        total_load = round(key['Total'], 6)
        sql = key['Dimensions'].get('db.sql.statement', 'Unknown SQL')
        sql_id = key['Dimensions'].get('db.sql.id', 'Unknown SQLID')
        full_sql=''
        if sql_id:
            full_sql = get_full_sql_stmt(pi_client, sql_id, db_resource_id, start_time, end_time, sql)
        print(f"Load: ${total_load}, SQL Id: ${sql_id}\nSQL: {full_sql}\n")

if __name__ == "__main__":
    main()

