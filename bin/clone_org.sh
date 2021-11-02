#!/bin/bash

#
#   Exit if input is empty.
#
if [[ $# -eq 0 ]]; then
    echo "Usage: clone_org -t <authorization_token> -o <organization>"
    exit 1
fi

#
#   Get/validate input from CL.
#
while [[ $# -gt 0 ]]
do
input_key="$1"
case $input_key in
    -t)
    TOKEN="$2"
    shift
    shift
    ;;
    -o)
    ORGANIZATION="$2"
    shift
    shift
    ;;
    *)
    echo "Usage: clone_org -t <authorization_token> -o <organization>"
    exit 1
    ;;
esac
done

if [ "$TOKEN" == "" ] || [ "$ORGANIZATION" == "" ]; then
    echo "Usage: clone_org -t <authorization_token> -o <organization>"
    exit 1
fi

#
#   Build authorization header
#
HEADER="Authorization: token ${TOKEN}"

#
#   Construct URL
#
URL="https://api.github.com/orgs/${ORGANIZATION}/repos?page=1&per_page=1"

#
#   Get number of repositories
#
num=$(curl -H ${HEADER} -sI ${URL} | grep -oP '.page=\K\d+\&per_page=1>; rel="last"' | awk -F "&" '{print $1}')

#
#   Check if $num is integer and more 0
#
re='^[0-9]+$'
if ! [[ $num =~ $re ]]; then
    echo "Invalid response from GitHub. Wrong organization name?"
    exit 1
fi

#
#   Clone loop
#
for ((i = 1; i <= $num; i++)) do
    URL="https://api.github.com/orgs/$ORGANIZATION/repos?page=${i}&per_page=1"
    curl -H ${HEADER} -s ${URL} | jq -r '.[].clone_url' | xargs -n 1 git clone
done

exit 0
