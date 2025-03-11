#!/usr/bin/python3

import sys
import os
import json
from datetime import datetime, timedelta
import boto3
from botocore.exceptions import UnauthorizedSSOTokenError, TokenRetrievalError
from colorama import Fore, Style, init
from prettytable import PrettyTable
import subprocess
from datetime import datetime, timedelta
from utils import check_if_logged_into_aws

#
# Functions
#
def list_all_aws_resources():
    print(list_all_aws_resources.__name__)

    # Define services to query
    services = {
        "EC2": "ec2",
        "S3": "s3",
        "Lambda": "lambda",
        "RDS": "rds",
        "DynamoDB": "dynamodb",
        "IAM": "iam",
        "SNS": "sns",
        "SQS": "sqs",
        "CloudWatch": "logs",
        "CloudFront": "cloudfront",
        "Lightsail": "lightsail",
        "Amplify": "amplify", 
        "VPC": "vpc",
        "ELB": "elbv2",
        "Route 53": "route53",
        "KMS": "kms",
        "ECR": "ecr",
        "SES": "ses"
    }

    session = boto3.Session()
    table = PrettyTable()
    table.field_names = ["Service", "Resource Type", "Resource Name/ID"]
    table.align = "l"

    # Fetch and list EC2 instances
    def check_ec2():
        ec2 = session.client("ec2", region_name=aws_region)
        response = ec2.describe_instances()
        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:
                table.add_row(["EC2", "Instance", instance["InstanceId"]])

    # Fetch and list S3 buckets
    def check_s3():
        s3 = session.client("s3", region_name=aws_region)
        response = s3.list_buckets()
        for bucket in response["Buckets"]:
            table.add_row(["S3", "Bucket", bucket["Name"]])

    # Fetch and list Lambda functions
    def check_lambda():
        lambda_client = session.client("lambda", region_name=aws_region)
        response = lambda_client.list_functions()
        for function in response["Functions"]:
            table.add_row(["Lambda", "Function", function["FunctionName"]])

    # Fetch and list RDS instances
    def check_rds():
        rds = session.client("rds", region_name=aws_region)
        response = rds.describe_db_instances()
        for db_instance in response["DBInstances"]:
            table.add_row(["RDS", "DB Instance", db_instance["DBInstanceIdentifier"]])

    # Fetch and list DynamoDB tables
    def check_dynamodb():
        dynamodb = session.client("dynamodb", region_name=aws_region)
        response = dynamodb.list_tables()
        for table_name in response["TableNames"]:
            table.add_row(["DynamoDB", "Table", table_name])

    def check_iam_users():
        iam = session.client("iam")
        users = iam.list_users()["Users"]
        if users:
            for user in users:
                table.add_row(["IAM", "User", user["UserName"]])

    def check_sns():
        sns = session.client("sns", region_name=aws_region)
        topics = sns.list_topics()["Topics"]
        if topics:
            for topic in topics:
                table.add_row(["SNS", "Topic", topic["TopicArn"]])

    def check_sqs():
        sqs = session.client("sqs", region_name=aws_region)
        queues = sqs.list_queues().get("QueueUrls", [])
        if queues:
            for queue in queues:
                table.add_row(["SQS", "Queue", queue])

    def check_cloudwatch_logs():
        logs = session.client("logs", region_name=aws_region)
        log_groups = logs.describe_log_groups().get("logGroups", [])
        if log_groups:
            for log_group in log_groups:
                table.add_row(["CloudWatch", "Log Group", log_group["logGroupName"]])

    def check_cloudfront():
        cloudfront = session.client("cloudfront")
        distributions = cloudfront.list_distributions()["DistributionList"].get("Items", [])
        if distributions:
            for distribution in distributions:
                table.add_row(["CloudFront", "Distribution", distribution["Id"]])

    def check_lightsail():
        lightsail = session.client("lightsail", region_name=aws_region)
        instances = lightsail.get_instances()["instances"]
        if instances:
            for instance in instances:
                table.add_row(["Lightsail", "Instance", instance["name"]])

    def check_amplify():
        amplify = session.client("amplify", region_name=aws_region)
        apps = amplify.list_apps()["apps"]
        if apps:
            for app in apps:
                table.add_row(["Amplify", "App", app["appId"]])

    def check_vpc():
        ec2 = session.client("ec2", region_name=aws_region)
        vpcs = ec2.describe_vpcs()["Vpcs"]
        if vpcs:
            for vpc in vpcs:
                table.add_row(["VPC", "VPC", vpc["VpcId"]])

    def check_load_balancers():
        elb = session.client("elbv2", region_name=aws_region)
        load_balancers = elb.describe_load_balancers()["LoadBalancers"]
        if load_balancers:
            for lb in load_balancers:
                table.add_row(["ELB", "Load Balancer", lb["LoadBalancerName"]])

    def check_elasticache():
        elasticache = session.client("elasticache", region_name=aws_region)
        clusters = elasticache.describe_cache_clusters()["CacheClusters"]
        if clusters:
            for cluster in clusters:
                table.add_row(["ElastiCache", "Cache Cluster", cluster["CacheClusterId"]])

    def check_route53():
        route53 = session.client("route53")
        hosted_zones = route53.list_hosted_zones()["HostedZones"]
        if hosted_zones:
            for zone in hosted_zones:
                table.add_row(["Route 53", "Hosted Zone", zone["Name"]])

    def check_kms():
        kms = session.client("kms", region_name=aws_region)
        keys = kms.list_keys()["Keys"]
        if keys:
            for key in keys:
                table.add_row(["KMS", "Key", key["KeyId"]])

    def check_ecr():
        ecr = session.client("ecr", region_name=aws_region)
        repositories = ecr.describe_repositories()["repositories"]
        if repositories:
            for repo in repositories:
                table.add_row(["ECR", "Repository", repo["repositoryName"]])

    def check_ses():
        ses = session.client("ses", region_name=aws_region)
        identities = ses.list_identities()["Identities"]
        if identities:
            for identity in identities:
                table.add_row(["SES", "Identity", identity])

    # Run functions to list resources
    check_ec2()
    check_s3()
    check_lambda()
    check_rds()
    check_dynamodb()
    #check_iam_users()
    check_sns()
    check_sqs()
    check_cloudwatch_logs()
    check_cloudfront()
    check_lightsail()
    check_amplify()
    check_vpc()
    check_load_balancers()
    check_elasticache()
    check_route53()
    check_kms()
    check_ecr()
    check_ses()

    # Print all resources in a pretty format
    print(table)

def list_ecs_clusters():
    print(list_ecs_clusters.__name__)
    ecs_client = boto3.client('ecs', region_name=aws_region)
    response = ecs_client.list_clusters()
    cluster_arns = response['clusterArns']
    print("\nECS Clusters")
    for cluster in cluster_arns:
        print(Fore.RED + Style.BRIGHT + '\t' + cluster.split('/')[-1] + ' (' + cluster + ')')
    print(Style.RESET_ALL)

def list_ecs_tasks(ecs_cluster_name):
    print(list_ecs_tasks.__name__ + '\nCluster :' + ecs_cluster_name)
    ecs_client = boto3.client('ecs', region_name=aws_region)
    task_arns = ecs_client.list_tasks(cluster=ecs_cluster_name)['taskArns']

    table = PrettyTable()
    table.field_names = ["Task ARN", "Task ID", "Last Status", "Service Name", "Desired Status", "Launch Type"]
    table.align = 'l'

    exec_cmd_table = PrettyTable()
    exec_cmd_table.field_names = ["Execute command"]

    if task_arns:
        tasks_info = ecs_client.describe_tasks(cluster=ecs_cluster_name, tasks=task_arns)['tasks']

        for task in tasks_info:
            task_arn = task['taskArn']
            task_id = task_arn.split("/")[-1]  # Extracts task ID from ARN
            last_status = task['lastStatus']
            desired_status = task['desiredStatus']
            launch_type = task.get('launchType', 'N/A')
            service_name = task['group'].split(":")[-1] if 'group' in task else 'N/A'
        
            # Add a row to the table for each task
            table.add_row([task_arn, task_id, last_status, service_name, desired_status, launch_type])
            exec_cmd_table.add_row([f'aws ecs execute-command --region eu-west-3 --cluster {ecs_cluster_name} --command "/bin/bash" --interactive --container {service_name} --task {task_id}'])
        print(table)
        print(exec_cmd_table)
    else:
         print("No tasks found in the cluster") 

def list_ecs_services(ecs_cluster_name):
    print(list_ecs_services.__name__ + '\nCluster :' + ecs_cluster_name)
    ecs_client = boto3.client('ecs', region_name=aws_region)

    table = PrettyTable()
    table.field_names = ["Service ARN", "Service Name", "Status", "Desired Count", "Running Count", "Launch Type"]
    table.align = 'l'

    service_arns = ecs_client.list_services(cluster=ecs_cluster_name)['serviceArns']
    
    if service_arns:
         services_info = ecs_client.describe_services(cluster=ecs_cluster_name, services=service_arns)['services']
         for service in services_info:
              service_arn = service['serviceArn']
              service_name = service['serviceName']
              status = service['status']
              desired_count = service['desiredCount']
              running_count = service['runningCount']
              launch_type = service.get('launchType', 'N/A')
              table.add_row([service_arn, service_name, status, desired_count, running_count, launch_type])
         print(table)
    else:
         print("No services found in the cluster.")

def get_billing_details_for_last_year():
    # Initialize Cost Explorer client
    client = boto3.client('ce')

    # Calculate the date range for the last 6 months
    end_date = datetime.today().replace(day=1)
    start_date = (end_date - timedelta(days=365)).replace(day=1)

    # Define time period and granularity
    time_period = {
        "Start": start_date.strftime("%Y-%m-%d"),
        "End": end_date.strftime("%Y-%m-%d")
    }

    # Call Cost Explorer API to get the cost and usage details
    response = client.get_cost_and_usage(
        TimePeriod=time_period,
        Granularity='MONTHLY',
        Metrics=['UnblendedCost']
    )

    # Set up the table
    table = PrettyTable()
    table.field_names = ["Month", "Cost (USD)"]
    table.align = 'l'

    # Extract cost data for each month
    for result in response['ResultsByTime']:
        month = result['TimePeriod']['Start'][:7]  # Format as "YYYY-MM"
        cost = result['Total']['UnblendedCost']['Amount']
        table.add_row([month, f"${float(cost):,.2f}"])

    # Display the table
    print(table)

def get_rds_events(days=7):
    # Initialize RDS client
    client = boto3.client('rds', region_name=aws_region)
    
    # Calculate the time range based on the number of days provided
    end_time = datetime.now()
    start_time = end_time - timedelta(days=days)
    
    # Call the describe_events API to get RDS events within the specified time range
    response = client.describe_events(StartTime=start_time, EndTime=end_time)
    
    # Set up the table to display the events
    table = PrettyTable()
    table.align = 'l'
    table.field_names = ["Event Time", "Source Type", "Source Identifier", "Message"]
    table.align = 'l'
    
    # Extract and add event data to the table
    if 'Events' in response:
        for event in response['Events']:
            event_time = event['Date'].strftime("%Y-%m-%d %H:%M:%S")
            source_type = event['SourceType']
            source_id = event.get('SourceIdentifier', 'N/A')
            message = event['Message']
            
            table.add_row([event_time, source_type, source_id, message])
    else:
        print(f"No events found for the last {days} days.")
        return
    
    # Display the table
    print(table)

def get_rds_log_entries(days=2):
    # Initialize CloudWatch Logs client
    client = boto3.client('logs', region_name=aws_region)

    # Calculate the time range based on the number of days provided
    end_time = int(datetime.now().timestamp() * 1000)  # Convert to milliseconds
    start_time = int((datetime.now() - timedelta(days=days)).timestamp() * 1000)

    # Set the log group for RDS logs
    log_group = "/aws/rds/instance"  # You can specify the exact log group name

    # Set up the log stream filter to query the logs
    query = "fields @timestamp, @message | sort @timestamp desc"
    
    try:
        # Start query execution
        response = client.start_query(
            logGroupName=log_group,
            startTime=start_time,
            endTime=end_time,
            queryString=query
        )
        
        query_id = response['queryId']
        print(f"Query started with ID: {query_id}")
        
        # Wait for the query to complete (poll every 3 seconds)
        result = None
        while result is None or result['status'] == 'Running':
            print("Waiting for query to complete...")
            result = client.get_query_results(
                queryId=query_id
            )
        
        # If results exist, display the entries in a pretty table
        if result['status'] == 'Complete':
            table = PrettyTable()
            table.align = 'l'
            table.field_names = ["Timestamp", "Log Message"]

            # Display the entries in the table
            for entry in result['results']:
                timestamp = entry[0]['value']
                message = entry[1]['value']
                table.add_row([timestamp, message])

            # Print the table
            print(table)
        else:
            print("No results found for the query.")
    
    except Exception as e:
        print(f"Error fetching logs: {e}")

#
# Main program
#

aws_region = os.getenv('AWS_REGION')
prod_ecs_cluster_name=os.getenv('PROD_ECS_CLUSTER_NAME')
stage_ecs_cluster_name=os.getenv('STAGE_ECS_CLUSTER_NAME')

if not aws_region:
    print("Please define AWS_REGION environment variable and retry")
    sys.exit()

if not prod_ecs_cluster_name:
    print("Please define PROD_ECS_CLUSTER_NAME environment variable and retry")
    sys.exit()

if not stage_ecs_cluster_name:
    print("Please define STAGE_ECS_CLUSTER_NAME environment variable and retry")
    sys.exit()


argsCount = len(sys.argv) - 1
if (argsCount < 1):
    print(f"\nUSAGE:{sys.argv[0]} <Function no>")
#    print(sys.argv[0])
    print (
    '''
        List all AWS resources                         - 0
        List ECS clusters                              - 1
        Get billing details for last one year          - 2
        Get RDS events for the last 7 days             - 3
        Get RDS log entries for the last 2 days        - 4

        Staging
            List all ECS staging tasks                 - 50
            List all ECS staging services              - 51

        Production
            List all ECS production tasks              - 100
            List all ECS production services           - 101
    '''
    )
    exit(0)

check_if_logged_into_aws(aws_region)

option = int(sys.argv[1])

if option == 0:
        list_all_aws_resources()
elif option == 1:
        list_ecs_clusters()
elif option == 2:
        get_billing_details_for_last_year()
elif option == 3:
        get_rds_events()
elif option == 4:
        get_rds_log_entries()
elif option == 50:
        list_ecs_tasks(stage_ecs_cluster_name)
elif option == 51:
        list_ecs_services(stage_ecs_cluster_name)
elif option == 100:
        list_ecs_tasks(prod_ecs_cluster_name)
elif option == 101:
        list_ecs_services(prod_ecs_cluster_name)
else:
      print("Unknown option")

exit(0)
