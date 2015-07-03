#!/bin/bash

set -e

source functions.sh

AMI_GROUP=$(
  aws \
    autoscaling \
    describe-tags \
    --filter 'Name=Value,Values=ami-creation' \
  | \
  jq \
    --raw-output \
    .Tags[0].ResourceId)

echo "`date` AMI creation auto scaling group is $AMI_GROUP"

aws \
  autoscaling \
  set-desired-capacity \
  --auto-scaling-group-name $AMI_GROUP \
  --desired-capacity 1

echo "`date` set $AMI_GROUP desired capacity to 1"

while true; do
  INSTANCE_ID=$(instances_in_pool ami-creation | head -n 1)
  if [ -n "$INSTANCE_ID" ]; then break; fi
  echo "`date` waiting for instance to be created"
  sleep 30
done

echo "`date` $INSTANCE_ID created, waiting for instance status ok"

aws \
  ec2 \
  wait \
  instance-status-ok \
  --instance-ids $INSTANCE_ID

PUBLIC_IP=$(
  aws \
    ec2 \
    describe-instances \
    --instance-ids $INSTANCE_ID \
  | \
  jq \
    --raw-output \
    .Reservations[0].Instances[0].PublicIpAddress)

echo "`date` public IP address is $PUBLIC_IP"

ssh-keyscan -H $PUBLIC_IP >> ~/.ssh/known_hosts

until ssh ec2-user@$PUBLIC_IP 'ls /user_data_finished'; do
  echo "`date` waiting for user data script to finish"
  sleep 30
done

IMAGE_ID=$(
  aws \
    ec2 \
    create-image \
    --instance-id $INSTANCE_ID \
    --name "memecaptain-`date +%Y%m%d%H%M%S`" \
    --description "memecaptain.com server" \
  | \
  jq \
    --raw-output \
    .ImageId)

echo "`date` waiting for image $IMAGE_ID to become available"

aws \
  ec2 \
  wait \
  image-available \
  --image-ids $IMAGE_ID

aws \
  autoscaling \
  set-desired-capacity \
  --auto-scaling-group-name $AMI_GROUP \
  --desired-capacity 0

echo "`date` set $AMI_GROUP desired capacity to 0"
