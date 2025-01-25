#!/bin/bash

TEMPLATE_FILE=$1
STACK_NAME=$2
IAM=$3
shift 3
PARAMETERS=$@

if [ -z "${TEMPLATE_FILE}" ] || [ -z "${STACK_NAME}" ] || [ -z "${IAM}" ]; then
  echo "USAGE: $0 <Template file> <Stack name> <IAM - YES/NO> [<ParameterKey=Key1,ParameterValue=Value1> ...]"
  exit 1
fi

# Function to check if the stack exists
stack_exists() {
  aws cloudformation describe-stacks --stack-name "${STACK_NAME}" > /dev/null 2>&1
}

set -x
if stack_exists; then
  echo "Stack ${STACK_NAME} exists. Updating stack."
  if [ "X${IAM}X" == "XNOX" ]; then
    aws cloudformation update-stack \
      --stack-name "${STACK_NAME}" \
      --template-body file://"${TEMPLATE_FILE}" \
      --parameters ${PARAMETERS}
  else
    aws cloudformation update-stack \
      --stack-name "${STACK_NAME}" \
      --template-body file://"${TEMPLATE_FILE}" \
      --parameters ${PARAMETERS} \
      --capabilities CAPABILITY_IAM
  fi
else
  echo "Stack ${STACK_NAME} does not exist. Creating stack."
  if [ "X${IAM}X" == "XNOX" ]; then
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
fi
