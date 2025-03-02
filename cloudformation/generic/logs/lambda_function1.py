import boto3
import cfnresponse
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Received event: %s", event)

    if 'ResourceProperties' not in event:
        logger.error("Missing 'ResourceProperties' in event.")
        cfnresponse.send(event, context, cfnresponse.FAILED, {'Error': "Missing 'ResourceProperties'"})
        return

    properties = event['ResourceProperties']
    hosted_zone_id = properties.get('HostedZoneId')
    vpc_id = properties.get('VPCId')
    region = properties.get('AWSRegion')

    if not hosted_zone_id or not vpc_id or not region:
        logger.error("One or more required parameters are missing.")
        cfnresponse.send(event, context, cfnresponse.FAILED, {'Error': "Missing HostedZoneId, VPCId, or AWSRegion"})
        return

    route53 = boto3.client('route53')

    try:
        response_auth = route53.create_vpc_association_authorization(
            HostedZoneId=hosted_zone_id,
            VPC={'VPCRegion': region, 'VPCId': vpc_id}
        )
        logger.info("VPC Association Authorization Response: %s", response_auth)
        cfnresponse.send(event, context, cfnresponse.SUCCESS, {'Message': 'VPC Association Authorization Created'})
    except Exception as e:
        logger.error("Error creating VPC Association Authorization: %s", str(e))
        cfnresponse.send(event, context, cfnresponse.FAILED, {'Error': str(e)})

