#!/usr/bin/python3

import boto3
import sys
from tabulate import tabulate
import os

def list_ec2_instances():
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    ec2_client = boto3.client('ec2', region_name=aws_region)
    response = ec2_client.describe_instances()
    
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            name = "N/A"
            for tag in instance.get('Tags', []):
                if tag['Key'] == 'Name':
                    name = tag['Value']
                    break
            instances.append([
                instance['InstanceId'],
                name,
                instance['State']['Name'],
                instance['InstanceType'],
                instance.get('PublicIpAddress', 'N/A'),
                instance.get('PrivateIpAddress', 'N/A')
            ])
    
    return instances

def list_rds_instances():
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    rds_client = boto3.client('rds', region_name=aws_region)
    response = rds_client.describe_db_instances()

    db_instances = []
    for db_instance in response['DBInstances']:
        db_name = db_instance.get('DBName', 'N/A')
        db_instance_id = db_instance['DBInstanceIdentifier']
        db_status = db_instance['DBInstanceStatus']
        db_engine = db_instance['Engine']
        db_instance_type = db_instance['DBInstanceClass']
        db_endpoint = db_instance.get('Endpoint', {}).get('Address', 'N/A')
        db_port = db_instance.get('Endpoint', {}).get('Port', 'N/A')
        
        db_instances.append([
            db_instance_id,
            db_name,
            db_status,
            db_engine,
            db_instance_type,
            db_endpoint,
            db_port
        ])

    return db_instances


def list_dms_tasks():
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    dms_client = boto3.client('dms', region_name=aws_region)
    response = dms_client.describe_replication_tasks()
    
    tasks = []
    for task in response['ReplicationTasks']:
        tasks.append([
            task['ReplicationTaskIdentifier'],
            task['ReplicationTaskArn'],
            task['Status']
        ])
    
    return tasks

def list_vpcs():
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    ec2_client = boto3.client('ec2', region_name=aws_region)
    response = ec2_client.describe_vpcs()

    vpcs = []
    for vpc in response['Vpcs']:
        vpc_id = vpc['VpcId']
        vpc_cidr = vpc['CidrBlock']
        vpc_state = vpc['State']
        vpc_tags = vpc.get('Tags', [])
        vpc_name = "N/A"
        for tag in vpc_tags:
            if tag['Key'] == 'Name':
                vpc_name = tag['Value']
                break
        vpcs.append([
            vpc_id,
            vpc_name,
            vpc_cidr,
            vpc_state
        ])

    return vpcs

def list_subnets():
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    ec2_client = boto3.client('ec2', region_name=aws_region)
    response = ec2_client.describe_subnets()
    subnets = []   
    for subnet in response['Subnets']:
        subnet_id = subnet['SubnetId']
        subnet_cidr = subnet['CidrBlock']
        subnet_vpc_id = subnet['VpcId']
        subnet_state = subnet['State']
        subnet_tags = subnet.get('Tags', [])
        subnet_name = "N/A"
        for tag in subnet_tags:
            if tag['Key'] == 'Name':
                subnet_name = tag['Value']
                break
        subnets.append([
            subnet_id,
            subnet_name,
            subnet_cidr,
            subnet_vpc_id,
            subnet_state
        ])
    return subnets

def list_aurora_clusters():
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    rds_client = boto3.client('rds', region_name=aws_region)
    response = rds_client.describe_db_clusters()
    clusters = []
    for cluster in response['DBClusters']:
        cluster_id = cluster['DBClusterIdentifier']
        cluster_status = cluster['Status']
        cluster_engine = cluster['Engine']
        cluster_instance_count = len(cluster.get('DBClusterMembers', []))
        clusters.append([
            cluster_id,
            cluster_status,
            cluster_engine,
            cluster_instance_count
        ])
    return clusters

#
# Function to get details
#
def get_ec2_details(instance_id):
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    ec2_client = boto3.client('ec2', region_name=aws_region)
    response = ec2_client.describe_instances(InstanceIds=[instance_id])
    
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            name = "N/A"
            for tag in instance.get('Tags', []):
                if tag['Key'] == 'Name':
                    name = tag['Value']
                    break
            print(f"Instance ID: {instance['InstanceId']}")
            print(f"Name: {name}")
            print(f"State: {instance['State']['Name']}")
            print(f"Instance Type: {instance['InstanceType']}")
            print(f"Public IP: {instance.get('PublicIpAddress', 'N/A')}")
            print(f"Private IP: {instance.get('PrivateIpAddress', 'N/A')}")
            print("-")

def get_dms_task_details(task_id):
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    dms_client = boto3.client('dms', region_name=aws_region)
    response = dms_client.describe_replication_tasks(Filters=[{"Name": "replication-task-id", "Values": [task_id]}])
    
    for task in response['ReplicationTasks']:
        print(f"Task ID: {task['ReplicationTaskIdentifier']}")
        print(f"Task ARN: {task['ReplicationTaskArn']}")
        print(f"Status: {task['Status']}")
        print("-")

def get_rds_cluster_details(cluster_id):
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    rds_client = boto3.client('rds', region_name=aws_region)
    response = rds_client.describe_db_clusters(DBClusterIdentifier=cluster_id)
    
    for cluster in response['DBClusters']:
        print(f"Cluster ID: {cluster['DBClusterIdentifier']}")
        print(f"Status: {cluster['Status']}")
        print(f"Engine: {cluster['Engine']}")
        print(f"Engine Version: {cluster['EngineVersion']}")
        print(f"Instance Count: {len(cluster.get('DBClusterMembers', []))}")
        print(f"Endpoint: {cluster.get('Endpoint', 'N/A')}")
        print(f"Port: {cluster.get('Port', 'N/A')}")
        print(f"Master Username: {cluster['MasterUsername']}")
        print(f"DB Cluster ARN: {cluster['DBClusterArn']}")
        print(f"Backup Retention Period: {cluster['BackupRetentionPeriod']} days")
        print(f"Preferred Backup Window: {cluster['PreferredBackupWindow']}")
        print(f"Preferred Maintenance Window: {cluster['PreferredMaintenanceWindow']}")
        print(f"Multi-AZ: {cluster['MultiAZ']}")
        print(f"Storage Encrypted: {cluster['StorageEncrypted']}")
        print(f"DB Cluster Parameter Group: {cluster['DBClusterParameterGroup']}")
        print(f"DB Subnet Group: {cluster['DBSubnetGroup']}")
        print(f"Vpc Security Groups: {[sg['VpcSecurityGroupId'] for sg in cluster['VpcSecurityGroups']]}")
        print(f"Associated Roles: {[role['RoleArn'] for role in cluster['AssociatedRoles']]}")
        print(f"Hosted Zone ID: {cluster.get('HostedZoneId', 'N/A')}")
        print(f"Cluster Create Time: {cluster['ClusterCreateTime']}")
        print("-")

def get_subnet_group_details(subnet_group_name):
    aws_region = os.getenv("AWS_REGION", "us-east-1")
    rds_client = boto3.client('rds', region_name=aws_region)
    response = rds_client.describe_db_subnet_groups(DBSubnetGroupName=subnet_group_name)
    
    for subnet_group in response['DBSubnetGroups']:
        print(f"Subnet Group Name: {subnet_group['DBSubnetGroupName']}")
        print(f"Description: {subnet_group['DBSubnetGroupDescription']}")
        print(f"Vpc ID: {subnet_group['VpcId']}")
        print(f"Subnet Group Status: {subnet_group['SubnetGroupStatus']}")
        
        subnets = []
        for subnet in subnet_group['Subnets']:
            subnets.append([
                subnet['SubnetIdentifier'],
                subnet['SubnetAvailabilityZone']['Name'],
                subnet['SubnetStatus']
            ])
        
        headers = ["Subnet ID", "Availability Zone", "Status"]
        print(tabulate(subnets, headers=headers, tablefmt="pretty", stralign="left"))
        print("-")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: list_aws_resources.py <Option>\n"
              "\t1 for EC2\n"
              "\t2 for DMS tasks\n"
              "\t3 for RDS instances\n"
              "\t4 for VPCs\n"
              "\t5 for Subnets\n"
              "\t6 for Aurora clusters\n"
              "Details\n"
              "\t103 for EC2 details [instance ID]\n"
              "\t104 for DMS details [task ID]\n"
              "\t105 for RDS cluster details [cluster ID]\n"
              "\t106 for Subnet group details [subnet group name]")
        sys.exit(1)
    
    option = sys.argv[1]
    
    if option == "1":
        instances = list_ec2_instances()
        headers = ["Instance ID", "Name", "State", "Instance Type", "Public IP", "Private IP"]
        print(tabulate(instances, headers=headers, tablefmt="pretty", stralign="left"))
    elif option == "2":
        tasks = list_dms_tasks()
        headers = ["Task ID", "Task ARN", "Status"]
        print(tabulate(tasks, headers=headers, tablefmt="pretty", stralign="left"))
    elif option == "3":
        rds_instances = list_rds_instances()
        headers = ["Instance Id", "Name", "Status", "Engine", "Instance Type", "Endpoint", "Port"]
        print(tabulate(rds_instances, headers=headers, tablefmt="pretty", stralign="left"))
    elif option == "4":
        vpcs = list_vpcs()
        headers = ["VPC ID", "Name", "CIDR Block", "State"]
        print(tabulate(vpcs, headers=headers, tablefmt="pretty", stralign="left"))
    elif option == "5":
        subnets = list_subnets()
        headers = ["Subnet ID", "Name", "CIDR Block", "VPC ID", "State"]
        print(tabulate(subnets, headers=headers, tablefmt="pretty", stralign="left"))
    elif option == "6":
        clusters = list_aurora_clusters()
        headers = ["Cluster ID", "Status", "Engine", "Instance Count"]
        print(tabulate(clusters, headers=headers, tablefmt="pretty", stralign="left"))
    elif option == "103":
        if len(sys.argv) != 3:
            print("Usage: list_aws_resources.py 103 <EC2 Instance ID>")
            sys.exit(1)
        get_ec2_details(sys.argv[2])
    elif option == "104":
        if len(sys.argv) != 3:
            print("Usage: list_aws_resources.py 104 <DMS Task ID>")
            sys.exit(1)
        get_dms_task_details(sys.argv[2])
    elif option == "105":
        if len(sys.argv) != 3:
            print("Usage: list_aws_resources.py 105 <RDS Cluster ID>")
            sys.exit(1)
        get_rds_cluster_details(sys.argv[2])
    elif option == "106":
        if len(sys.argv) != 3:
            print("Usage: list_aws_resources.py 106 <Subnet Group Name>")
            sys.exit(1)
        get_subnet_group_details(sys.argv[2])
    else:
        print("Invalid option. Usage: python script.py <1 for EC2 | 2 for DMS tasks | 3 for EC2 details | 4 for DMS details>")
        sys.exit(1)

