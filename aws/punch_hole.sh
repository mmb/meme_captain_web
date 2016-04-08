#!/bin/bash

set -eu

MY_IP=$(curl https://api.ipify.org)

NAT_IP=$(
  aws \
    ec2 \
    describe-instances \
    --filters Name=tag-key,Values=pool Name=tag-value,Values=nat | \
  jq \
    --raw-output \
    .Reservations[0].Instances[0].PublicIpAddress
)

NAT_GROUP_ID=$(
  aws \
    ec2 \
    describe-security-groups \
    --filters Name=tag-key,Values=Name Name=tag-value,Values=nat | \
  jq \
    --raw-output \
    .SecurityGroups[0].GroupId
)

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
echo "nat ip address        : $NAT_IP"
echo "nat security group id : $NAT_GROUP_ID"
echo "web security group id : $WEB_GROUP_ID"

open_hole() {
  echo "🔓  opening inbound tcp port 22 from $NAT_GROUP_ID to $WEB_GROUP_ID"
  aws \
    ec2 \
    authorize-security-group-ingress \
    --group-id $WEB_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --source-group $NAT_GROUP_ID

  echo "🔓  opening outbound tcp port 22 from $NAT_GROUP_ID to $WEB_GROUP_ID"
  aws \
    ec2 \
    authorize-security-group-egress \
    --group-id $NAT_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --source-group $WEB_GROUP_ID

  echo "🔓  opening inbound tcp port 22 from $MY_IP/32 to $NAT_GROUP_ID"
  aws \
    ec2 \
    authorize-security-group-ingress \
    --group-id $NAT_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr $MY_IP/32
}

close_hole() {
  echo "🔒  closing inbound tcp port 22 from $MY_IP/32 to $NAT_GROUP_ID"
  aws \
    ec2 \
    revoke-security-group-ingress \
    --group-id $NAT_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr $MY_IP/32

  echo "🔒  closing outbound tcp port 22 from $NAT_GROUP_ID to $WEB_GROUP_ID"
  aws \
    ec2 \
    revoke-security-group-egress \
    --group-id $NAT_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --source-group $WEB_GROUP_ID

  echo "🔒  closing inbound tcp port 22 from $NAT_GROUP_ID to $WEB_GROUP_ID"
  aws \
    ec2 \
    revoke-security-group-ingress \
    --group-id $WEB_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --source-group $NAT_GROUP_ID
}

open_hole
ssh -A ec2-user@$NAT_IP
close_hole
