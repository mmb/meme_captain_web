#!/bin/bash

set -eu

MY_IP=$(curl https://api.ipify.org)

WEB_GROUP_ID=$(
  aws \
    ec2 \
    describe-security-groups \
    --filters Name=tag-key,Values=Name Name=tag-value,Values=web | \
  jq \
    --raw-output \
    .SecurityGroups[0].GroupId
)

echo "public ip address     : $MY_IP"
echo "web security group id : $WEB_GROUP_ID"

open_hole() {
  echo "🔓  opening inbound tcp port 22 from $MY_IP/32 to $WEB_GROUP_ID"
  aws \
    ec2 \
    authorize-security-group-ingress \
    --group-id $WEB_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr $MY_IP/32
}

close_hole() {
  echo "🔒  closing inbound tcp port 22 from $MY_IP/32 to $WEB_GROUP_ID"
  aws \
    ec2 \
    revoke-security-group-ingress \
    --group-id $WEB_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr $MY_IP/32
}

open_hole
echo 'Press ENTER to close hole'
read
close_hole
