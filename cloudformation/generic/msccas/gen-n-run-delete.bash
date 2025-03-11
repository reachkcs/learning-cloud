#!/bin/bash
function generate_delete_script() {
  local AWS_PROFILE="$1"
  
  local DEL_FILE="./del-${AWS_PROFILE}.bash"
  echo "#!/bin/bash" > "${DEL_FILE}"
  echo "export AWS_PROFILE=${AWS_PROFILE}" >> "${DEL_FILE}"
  chmod +x "${DEL_FILE}"
  
  for STACK in $(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE \
    --query 'StackSummaries[*].[StackName,CreationTime]' --output table | sort -k2 | grep '2025' | awk '{print $2}')
  do
    CMD="delete_cw_stack.bash ${STACK}"
    echo "Stack is <${STACK}>. Command is <${CMD}>"
    echo "${CMD}" >> "${DEL_FILE}"
  done
  
  echo "Delete stack file is: ${DEL_FILE}"
}

generate_delete_script "KCS-Personal-anukcs-gmail"
generate_delete_script "KCS-Personal-reachsreedhar-kcs"
