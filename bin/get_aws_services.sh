#!/bin/bash

#
#   Check awscli is configured
#
AWSCONFIG=$(aws configure get aws_access_key_id)
if [[ $AWSCONFIG == "" ]]; then
    echo "You need to run \"aws configure\" first"
    exit 1
fi

#
#   Get full AWS services list to array
#
mapfile AWSSERVICES < <(aws ssm get-parameters-by-path --path /aws/service/global-infrastructure/services --output json | jq '.Parameters[].Name' | sed s/\"//g | sort)

#
#   Main loop for getting Name and Full name values
#
JSON="{"
for (( i=0; i<${#AWSSERVICES[@]}; i++ )); do
    JSON+="\""
    SERVICE=$(echo ${AWSSERVICES[i]} | awk -F "/" '{print $NF}')
    JSON+=$SERVICE
    printf "\r\033[KCollecting info for \"${SERVICE//$'\n'}\""
    JSON+="\": {\"Name\": "
    JSON+=$(aws ssm get-parameters-by-path --path ${AWSSERVICES[i]} --output json | jq '.Parameters[].Value' | head -1)
    JSON+="}"
    if (( $i != ${#AWSSERVICES[@]}-1 )); then
	JSON+=","
    fi
done
JSON+="}"

#
#   Output pretty JSON
#
echo $JSON | jq '.' > services.json
