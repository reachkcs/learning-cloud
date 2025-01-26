#!/bin/bash
export TEMPLATE_FILE=$1

if [ -z ${TEMPLATE_FILE} ];then
  echo "USAGE: $0 <Template file>"
  exit 0
fi

set -x
aws cloudformation create-stack --stack-name KCS-TEMP-VPC --template-body file://${TEMPLATE_FILE} --parameters ParameterKey=TransitGatewayId,ParameterValue=tgw-017c70b9b80c78ae7 ParameterKey=VPCName,ParameterValue=KCS-TEMP ParameterKey=EnvironmentName,ParameterValue=PROD ParameterKey=EnvironmentDescription,ParameterValue='Temp-VPC' ParameterKey=ENVType,ParameterValue=P
