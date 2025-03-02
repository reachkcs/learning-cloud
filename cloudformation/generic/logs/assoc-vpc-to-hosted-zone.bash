#!/bin/bash
export HOSTED_ZONE_ID=$1
export VPC_ID=$2

if [ -z ${HOSTED_ZONE_ID} ] || [ -z ${VPC_ID} ];then
  echo "USAGE: $0 <Hosted zone id> <VPC id>"
  exit 0
fi

export AWS_REGION=us-east-1

#export AWS_PROFILE=KCS-Personal-anukcs-gmail

set -x
#aws route53 create-vpc-association-authorization --hosted-zone-id ${HOSTED_ZONE_ID} --vpc VPCRegion=${AWS_REGION},VPCId=${VPC_ID}

#export AWS_PROFILE=KCS-Personal-reachsreedhar-kcs
export AWS_PROFILE=KCS-Test-Lambda
aws route53 associate-vpc-with-hosted-zone --hosted-zone-id ${HOSTED_ZONE_ID} --vpc VPCRegion=${AWS_REGION},VPCId=${VPC_ID}
