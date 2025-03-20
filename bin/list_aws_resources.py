#!/usr/bin/python3

import boto3
import sys
from tabulate import tabulate

def list_ec2_instances():
    ec2_client = boto3.client('ec2')
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

import boto3

def list_rds_instances():
    rds_client = boto3.client('rds')
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
    dms_client = boto3.client('dms')
    response = dms_client.describe_replication_tasks()
    
    tasks = []
    for task in response['ReplicationTasks']:
        tasks.append([
            task['ReplicationTaskIdentifier'],
            task['ReplicationTaskArn'],
            task['Status']
        ])
    
    return tasks

def get_ec2_details(instance_id):
    ec2_client = boto3.client('ec2')
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
    dms_client = boto3.client('dms')
    response = dms_client.describe_replication_tasks(Filters=[{"Name": "replication-task-id", "Values": [task_id]}])
    
    for task in response['ReplicationTasks']:
        print(f"Task ID: {task['ReplicationTaskIdentifier']}")
        print(f"Task ARN: {task['ReplicationTaskArn']}")
        print(f"Status: {task['Status']}")
        print("-")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <1 for EC2 | 2 for DMS tasks | 3 for EC2 details | 4 for DMS details> [instance/task ID]")
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
    elif option == "103":
        if len(sys.argv) != 3:
            print("Usage: python script.py 3 <EC2 Instance ID>")
            sys.exit(1)
        get_ec2_details(sys.argv[2])
    elif option == "104":
        if len(sys.argv) != 3:
            print("Usage: python script.py 4 <DMS Task ID>")
            sys.exit(1)
        get_dms_task_details(sys.argv[2])
    else:
        print("Invalid option. Usage: python script.py <1 for EC2 | 2 for DMS tasks | 3 for EC2 details | 4 for DMS details>")
        sys.exit(1)

