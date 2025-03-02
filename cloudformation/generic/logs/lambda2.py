#!/usr/bin/python3

import boto3
import logging
import sys

logger = logging.getLogger()
logger.setLevel(logging.INFO)
handler = logging.StreamHandler(sys.stdout)

# Set the log format
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

# Add the handler to the logger
logger.addHandler(handler)

def lambda_handler():
    hosted_zone_id = 'Z08604073O75TJLZ62435'
    vpc_id = 'vpc-0b6314168771c4573'
    region = 'us-east-1'

    route53 = boto3.client('route53')

    try:
        response_assoc = route53.associate_vpc_with_hosted_zone(
            HostedZoneId=hosted_zone_id,
            VPC={'VPCRegion': region, 'VPCId': vpc_id}
        )
        logger.info("VPC Association Response: %s", response_assoc)
    except Exception as e:
        logger.error("Error associating VPC with Hosted Zone: %s", str(e))

lambda_handler()
