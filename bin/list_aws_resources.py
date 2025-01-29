#!/usr/bin/python3
import boto3
import os

def list_vpcs(ec2_client):
    print("Listing VPCs:")
    vpcs = ec2_client.describe_vpcs()['Vpcs']
    for vpc in vpcs:
        print(f"\tVPC ID: {vpc['VpcId']}, CIDR: {vpc['CidrBlock']}")

def list_ec2_instances(ec2_client):
    print("Listing EC2 Instances:")
    instances = ec2_client.describe_instances()['Reservations']
    for reservation in instances:
        for instance in reservation['Instances']:
            print(f"\tInstance ID: {instance['InstanceId']}, State: {instance['State']['Name']}")

def list_load_balancers(elbv2_client):
    print("Listing Load Balancers:")
    load_balancers = elbv2_client.describe_load_balancers()['LoadBalancers']
    for lb in load_balancers:
        print(f"\tLoad Balancer Name: {lb['LoadBalancerName']}, ARN: {lb['LoadBalancerArn']}")

def list_security_groups(ec2_client):
    print("Listing Security Groups:")
    security_groups = ec2_client.describe_security_groups()['SecurityGroups']
    for sg in security_groups:
        print(f"\tSecurity Group ID: {sg['GroupId']}, Name: {sg['GroupName']}")

def list_endpoints(ec2_client):
    print("Listing Endpoints:")
    endpoints = ec2_client.describe_vpc_endpoints()['VpcEndpoints']
    for endpoint in endpoints:
        print(f"\tEndpoint ID: {endpoint['VpcEndpointId']}, Service: {endpoint['ServiceName']}")

def list_endpoint_services(ec2_client):
    print("Listing Endpoint Services:")
    endpoint_services = ec2_client.describe_vpc_endpoint_services()['ServiceDetails']
    for service in endpoint_services:
        print(f"\tService Name: {service['ServiceName']}")

def list_s3_buckets(s3_client):
    print("Listing S3 Buckets:")
    buckets = s3_client.list_buckets()['Buckets']
    for bucket in buckets:
        print(f"\tBucket Name: {bucket['Name']}")

def list_subnets(ec2_client):
    print("Listing Subnets:")
    subnets = ec2_client.describe_subnets()['Subnets']
    for subnet in subnets:
        print(f"\tSubnet ID: {subnet['SubnetId']}, CIDR: {subnet['CidrBlock']}")

def list_route_tables(ec2_client):
    print("Listing Route Tables:")
    route_tables = ec2_client.describe_route_tables()['RouteTables']
    for rt in route_tables:
        print(f"\tRoute Table ID: {rt['RouteTableId']}")

def list_target_groups(elbv2_client):
    print("Listing Target Groups:")
    target_groups = elbv2_client.describe_target_groups()['TargetGroups']
    for tg in target_groups:
        print(f"\tTarget Group Name: {tg['TargetGroupName']}, ARN: {tg['TargetGroupArn']}")

def list_listeners(elbv2_client):
    print("Listing Listeners:")
    
    # First, list all load balancers to get their ARNs
    load_balancers = elbv2_client.describe_load_balancers()['LoadBalancers']
    
    for lb in load_balancers:
        load_balancer_arn = lb['LoadBalancerArn']
        print(f"\tLoad Balancer ARN: {load_balancer_arn}")
        
        # Now, describe listeners for this load balancer
        listeners = elbv2_client.describe_listeners(LoadBalancerArn=load_balancer_arn)['Listeners']
        for listener in listeners:
            print(f"\tListener ARN: {listener['ListenerArn']}, Port: {listener['Port']}, Protocol: {listener['Protocol']}")

def list_route53_zones(route53_client):
    print("Listing Route53 Hosted Zones:")
    hosted_zones = route53_client.list_hosted_zones()['HostedZones']
    for zone in hosted_zones:
        print(f"\tHosted Zone ID: {zone['Id']}, Name: {zone['Name']}")

def list_cloudfront_distributions(cloudfront_client):
    print("Listing CloudFront Distributions:")
    response = cloudfront_client.list_distributions()
    
    # Check if 'Items' key exists in the response
    if 'Items' in response['DistributionList']:
        distributions = response['DistributionList']['Items']
        for dist in distributions:
            print(f"\tDistribution ID: {dist['Id']}, Domain: {dist['DomainName']}")
    else:
        print("No CloudFront distributions found.")

def list_certificates(acm_client):
    print("Listing ACM Certificates:")
    certificates = acm_client.list_certificates()['CertificateSummaryList']
    for cert in certificates:
        print(f"\tCertificate ARN: {cert['CertificateArn']}, Domain: {cert['DomainName']}")

def main():
    aws_region = os.getenv('AWS_REGION')
    ec2_client = boto3.client('ec2', region_name=aws_region)
    elbv2_client = boto3.client('elbv2', region_name=aws_region)
    s3_client = boto3.client('s3', region_name=aws_region)
    route53_client = boto3.client('route53', region_name=aws_region)
    cloudfront_client = boto3.client('cloudfront', region_name=aws_region)
    acm_client = boto3.client('acm', region_name=aws_region)

    list_vpcs(ec2_client)
    list_ec2_instances(ec2_client)
    list_load_balancers(elbv2_client)
    list_security_groups(ec2_client)
    list_endpoints(ec2_client)
    list_endpoint_services(ec2_client)
    list_s3_buckets(s3_client)
    list_subnets(ec2_client)
    list_route_tables(ec2_client)
    list_target_groups(elbv2_client)
    list_listeners(elbv2_client)
    list_route53_zones(route53_client)
    list_cloudfront_distributions(cloudfront_client)
    list_certificates(acm_client)

if __name__ == "__main__":
    main()