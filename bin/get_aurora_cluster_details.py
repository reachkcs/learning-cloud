#!/usr/bin/python3

import boto3
from prettytable import PrettyTable
import sys
import os
from colorama import Fore, Style, init
from botocore.exceptions import UnauthorizedSSOTokenError, TokenRetrievalError
from utils import check_if_logged_into_aws

def list_aurora_clusters(rds_client):
    try:
        # Describe all DB clusters
        response = rds_client.describe_db_clusters()

        # Extract cluster identifiers
        cluster_identifiers = [cluster['DBClusterIdentifier'] for cluster in response['DBClusters']]
        
        if cluster_identifiers:
            return cluster_identifiers
        else:
            print("No Aurora clusters found.")
            exit(0)

    except Exception as e:
        print(f"Error fetching Aurora clusters: {e}")

def get_aurora_cluster_details(rds_client, cluster_identifier):
    
    try:
        # Fetch cluster details
        response = rds_client.describe_db_clusters(DBClusterIdentifier=cluster_identifier)
        cluster = response['DBClusters'][0]
        
        # Create a PrettyTable
        table = PrettyTable()
        table.align = "l"
        table.field_names = ["Attribute", "Value"]

        # Add details to the table
        table.add_row(["Cluster Identifier", cluster['DBClusterIdentifier']])
        table.add_row(["Engine", cluster['Engine']])
        table.add_row(["Engine Version", cluster['EngineVersion']])
        table.add_row(["Status", cluster['Status']])
        table.add_row(["Endpoint", cluster['Endpoint']])
        table.add_row(["Reader Endpoint", cluster.get('ReaderEndpoint', 'N/A')])
        table.add_row(["Port", cluster['Port']])
        table.add_row(["Master Username", cluster['MasterUsername']])
        table.add_row(["Backup Retention Period", cluster['BackupRetentionPeriod']])
        table.add_row(["Preferred Backup Window", cluster['PreferredBackupWindow']])
        table.add_row(["Preferred Maintenance Window", cluster['PreferredMaintenanceWindow']])
        table.add_row(["Cluster Create Time", cluster['ClusterCreateTime']])
        table.add_row(["DB Cluster Members", ", ".join([member['DBInstanceIdentifier'] for member in cluster['DBClusterMembers']])])
        table.add_row(["Associated Roles", ", ".join([role['RoleArn'] for role in cluster.get('AssociatedRoles', [])])])
        for row in table._rows:
            row[0] = f"{Fore.RED}{row[0]}{Style.RESET_ALL}"

        print(table)
    except Exception as e:
        print(f"Error fetching details for cluster '{cluster_identifier}': {e}")

if __name__ == "__main__":
    aws_region = os.getenv('AWS_REGION')
    if not aws_region:
        print("Please define AWS_REGION environment variable and retry")
        sys.exit()

    check_if_logged_into_aws(aws_region)

    # Initialize RDS client
    rds_client = boto3.client('rds', region_name=aws_region)
    cluster_identifiers = list_aurora_clusters(rds_client)

    for aurora_cluster_id in cluster_identifiers:
        get_aurora_cluster_details(rds_client, aurora_cluster_id)

