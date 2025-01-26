#!/bin/bash
export STACK_NAME=$1

if [ -z ${STACK_NAME} ];then
  echo "USAGE: $0 <Stack name>"
  exit 0
fi

set -x
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
