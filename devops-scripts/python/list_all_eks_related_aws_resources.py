#!/usr/bin/python3

import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

def list_eks_resources(region_name):
    """
    Lists all AWS resources related to the EKS service in a given region.
    
    :param region_name: AWS region
    :return: A dictionary of EKS-related resources
    """
    eks_resources = {
        "Clusters": [],
        "NodeGroups": {},
        "FargateProfiles": {},
        "LoadBalancers": [],
        "SecurityGroups": [],
        "VPCs": [],
        "Subnets": []
    }
    
    try:
        # Initialize AWS clients
        eks_client = boto3.client("eks", region_name=region_name)
        ec2_client = boto3.client("ec2", region_name=region_name)
        elb_client = boto3.client("elbv2", region_name=region_name)

        # 1. List all EKS clusters
        clusters = eks_client.list_clusters()["clusters"]
        eks_resources["Clusters"] = clusters
        print(f"Found {len(clusters)} EKS clusters: {clusters}")

        for cluster_name in clusters:
            # 2. Get details of each cluster
            cluster_info = eks_client.describe_cluster(name=cluster_name)["cluster"]
            vpc_id = cluster_info["resourcesVpcConfig"]["vpcId"]
            eks_resources["VPCs"].append(vpc_id)

            # List subnets
            subnets = cluster_info["resourcesVpcConfig"]["subnetIds"]
            eks_resources["Subnets"].extend(subnets)

            # List security groups
            security_groups = cluster_info["resourcesVpcConfig"]["securityGroupIds"]
            eks_resources["SecurityGroups"].extend(security_groups)

            # 3. List node groups for the cluster
            node_groups = eks_client.list_nodegroups(clusterName=cluster_name)["nodegroups"]
            eks_resources["NodeGroups"][cluster_name] = node_groups

            # 4. List Fargate profiles for the cluster
            fargate_profiles = eks_client.list_fargate_profiles(clusterName=cluster_name)["fargateProfileNames"]
            eks_resources["FargateProfiles"][cluster_name] = fargate_profiles

            print(f"\nCluster: {cluster_name}")
            print(f"  VPC: {vpc_id}")
            print(f"  Subnets: {subnets}")
            print(f"  Security Groups: {security_groups}")
            print(f"  Node Groups: {node_groups}")
            print(f"  Fargate Profiles: {fargate_profiles}")

        # 5. List Load Balancers (associated with EKS)
        load_balancers = elb_client.describe_load_balancers()["LoadBalancers"]
        for lb in load_balancers:
            if "eks" in lb["LoadBalancerArn"].lower():
                eks_resources["LoadBalancers"].append(lb)

        # Deduplicate resources like Security Groups and Subnets
        eks_resources["Subnets"] = list(set(eks_resources["Subnets"]))
        eks_resources["SecurityGroups"] = list(set(eks_resources["SecurityGroups"]))

    except NoCredentialsError:
        print("AWS credentials not found. Please configure them.")
    except PartialCredentialsError as e:
        print(f"Partial credentials error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

    return eks_resources

# Example usage
if __name__ == "__main__":
    region = "us-east-1"  # Change to your AWS region
    eks_resources = list_eks_resources(region)
    print("\nSummary of EKS Resources:")
    for key, value in eks_resources.items():
        print(f"{key}: {value}")

