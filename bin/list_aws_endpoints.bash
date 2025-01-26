#!/bin/bash

echo "Fetching all VPC endpoints and their details..."
CSV_FILE=/tmp/vpd_endpoints_details.csv
T_FILE=/tmp/vpd_endpoints_details.txt

# Fetch all VPC endpoints
ENDPOINTS=$(aws ec2 describe-vpc-endpoints --query "VpcEndpoints[*]" --output json)

if [[ -z $ENDPOINTS || $ENDPOINTS == "[]" ]]; then
  echo "No VPC endpoints found in the account."
  exit 0
fi

# Parse and display the endpoint information
echo -e "\nVPC Endpoint Details:"
echo "------------------------------------------------------------------------------------------------------------" >> ${T_FILE}
printf "%-20s %-41s %-15s %-50s\n" "Name" "Service Name" "Endpoint" "Private IPs" > ${T_FILE}
printf "%s,%s,%s,%s\n" "Name" "Service Name" "Endpoint" "Private IPs" > ${CSV_FILE}
echo "------------------------------------------------------------------------------------------------------------" >> ${T_FILE}

echo "$ENDPOINTS" | jq -c '.[]' | while read -r ENDPOINT; do

  NAME=$(echo "$ENDPOINT" | jq -r '.Tags[] | select(.Key=="Name") | .Value' 2>/dev/null || echo "N/A")
  SERVICE_NAME=$(echo "$ENDPOINT" | jq -r '.ServiceName')
  ENDPOINT_TYPE=$(echo "$ENDPOINT" | jq -r '.VpcEndpointType')
  
  # Get the network interfaces and their private IPs
  NETWORK_INTERFACES=$(echo "$ENDPOINT" | jq -r '.NetworkInterfaceIds[]?' | xargs 2>/dev/null)
  PRIVATE_IPS=""
  
  echo "Working on the endpoint ${NAME} (Service name: ${SERVICE_NAME}, Endpoint type: ${ENDPOINT_TYPE})"
  echo "  Network interfaces: <${NETWORK_INTERFACES}>"
  for INTERFACE in $NETWORK_INTERFACES; do
    IP=$(aws ec2 describe-network-interfaces --network-interface-ids "${INTERFACE}" --query "NetworkInterfaces[0].PrivateIpAddress" --output text 2>/dev/null)
    echo "    Interface: <${INTERFACE}> Its IP: ${IP}"
    PRIVATE_IPS+="$IP "
  done
  
  # Print the endpoint details
  printf "%-20s %-41s %-15s %-50s\n" "$NAME" "$SERVICE_NAME" "$ENDPOINT_TYPE" "${PRIVATE_IPS:-n/a}" >> ${T_FILE}
  printf "%s,%s,%s,%s\n" "$NAME" "$SERVICE_NAME" "$ENDPOINT_TYPE" "${PRIVATE_IPS:-n/a}" >> ${CSV_FILE}
done

cat ${T_FILE}
echo;echo "Output is also in the CSV format in this file: ${CSV_FILE}"


