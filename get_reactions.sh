#!/bin/bash 

if [ -z "$1" ]; then
    echo "Usage: $0 <slack_url>"
    exit 1
fi
URL=$1

workspace=$(echo $URL | sed -E 's|(https://[^/]+).*|\1|')
cid=$(echo $URL | sed -E 's|.*/archives/([^/]+)/p.*|\1|')
ts=$(echo $URL | sed -E 's|.*/archives/[^/]+/p([0-9]{10})([0-9]{6}).*|\1.\2|')

ly-slack -s -F channel=$cid -F timestamp=$ts -F full=true ${workspace}/api/reactions.get | jq '.message.reactions[].users[]' | tr -d '"' | sort | uniq