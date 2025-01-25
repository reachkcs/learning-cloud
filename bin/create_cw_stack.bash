#!/bin/bash
TEMPLATE_FILE=$1
STACK_NAME=$2
IAM=$3
shift 3
PARAMETERS=$@

if [ -z "${TEMPLATE_FILE}" ] || [ -z "${STACK_NAME}" ] || [ -z ${IAM} ]; then
  echo "USAGE: $0 <Template file> <Stack name> <IAM - YES/NO> [<ParameterKey=Key1,ParameterValue=Value1> ...]"
  exit 1
fi

set -x
if [ "X${IAM}X" == "XNOX" ];then
  aws cloudformation create-stack \
    --stack-name "${STACK_NAME}" \
    --template-body file://"${TEMPLATE_FILE}" \
    --parameters ${PARAMETERS}
else
  aws cloudformation create-stack \
    --stack-name "${STACK_NAME}" \
    --template-body file://"${TEMPLATE_FILE}" \
    --parameters ${PARAMETERS} \
    --capabilities CAPABILITY_IAM
fi
