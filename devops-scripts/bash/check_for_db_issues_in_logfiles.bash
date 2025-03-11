#!/bin/bash
DIR_PATH=$1
export SLACK_CHANNEL="#alerts"
#export SLACK_CHANNEL="#tech"

if [ -z ${DIR_PATH} ];then
  echo "USAGE: $0 <Directory path>"
  exit 0
fi

cd ${DIR_PATH}

send_slack_message() {
    local message="$@"

    if [[ -z "$message" ]]; then
        echo "Error: No message provided."
        echo "Usage: $0 '<message>'"
        return 1
    fi

    # Run the Python script with the message
    ${SDIR}/devops-scripts/python/send_slack_message_using_token.py "${SLACK_CHANNEL}" "$message"

    if [[ $? -eq 0 ]]; then
        echo "Message sent successfully: $message"
    else
        echo "Failed to send message: $message"
    fi
}

scan_directory_for_keywords() {
  local dir="$1"
  local keywords=("FATAL" "PANIC" "DETAIL" "ERROR" "LOG" "STATEMENT")

  if [[ ! -d "$dir" ]]; then
    echo "Error: Directory '$dir' does not exist."
    return 1
  fi

  slack_message="PG logs scanning summary for yesterday (Folder: \`${dir}\` on bastion server)
  \`\`\`"
  echo "PG logs scanning summary for yesterday (Folder: $dir on bastion server)"
  #send_slack_message "PG logs scanning summary for yesterday (Folder: $dir on bastion server)"

  for keyword in "${keywords[@]}"; do
    # Count lines with the keyword
    count=$(grep -r "$keyword" "$dir" 2>/dev/null | wc -l)

    if [[ $count -gt 0 ]]; then
      echo "$keyword: $count line(s) found"
      #send_slack_message "$keyword: $count line(s) found"
      slack_message+="$keyword: $count line(s) found
"
    else
      echo "$keyword: No entries found with this string"
      #send_slack_message "$keyword: No entries found with this string"
      slack_message+="$keyword: No entries found with this string
"
    fi
  done
  slack_message+=" \`\`\`"
  echo "slack message: <${slack_message}>"
  send_slack_message "${slack_message}"
}

scan_directory_for_keywords "${DIR_PATH}"

exit 0
