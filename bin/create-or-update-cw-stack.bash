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

# Function to get the stack status
get_stack_status() {
  aws cloudformation describe-stacks --stack-name "${STACK_NAME}" --query "Stacks[0].StackStatus" --output text 2>/dev/null
}

# Function to delete the stack
delete_stack() {
  echo "Deleting stack ${STACK_NAME}..."
  aws cloudformation delete-stack --stack-name "${STACK_NAME}"
  echo "Waiting for stack ${STACK_NAME} to be deleted..."
  aws cloudformation wait stack-delete-complete --stack-name "${STACK_NAME}"
  echo "Stack ${STACK_NAME} deleted."
}

create_stack() {
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
}

if stack_exists; then
  STACK_STATUS=$(get_stack_status)
  echo "Stack ${STACK_NAME} exists with status ${STACK_STATUS}."

  if [ "${STACK_STATUS}" == "ROLLBACK_COMPLETE" ]; then
    echo "Stack ${STACK_NAME} is in ROLLBACK_COMPLETE state. Deleting stack."
    delete_stack
    echo "Stack ${STACK_NAME} has been deleted. Recreating stack."
    create_stack
  else
    echo "Updating stack ${STACK_NAME}."
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
  fi
else
  echo "Stack ${STACK_NAME} does not exist. Creating stack."
  create_stack
fi
