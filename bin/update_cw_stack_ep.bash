#!/bin/bash
export TEMPLATE_FILE=$1

if [ -z ${TEMPLATE_FILE} ];then
  echo "USAGE: $0 <Template file>"
  exit 0
fi

set -x
aws cloudformation update-stack --stack-name KCS-TEMP-EP --template-body file://${TEMPLATE_FILE} --parameters ParameterKey=VPCExportName,ParameterValue=PROD-KCS-TEMP ParameterKey=ENVType,ParameterValue=P
