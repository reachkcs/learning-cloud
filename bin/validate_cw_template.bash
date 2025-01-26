#!/bin/bash
export TEMPLATE_FILE=$1

if [ -z ${TEMPLATE_FILE} ];then
  echo "USAGE: $0 <Template file>"
  exit 0
fi

set -x
aws cloudformation validate-template --template-body file://${TEMPLATE_FILE}
