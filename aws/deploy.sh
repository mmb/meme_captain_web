#!/bin/bash

set -e

source functions.sh

STACK_NAME=memecaptain
AMI="$1"

if [ -z "$AMI" ]; then
  echo "Usage: $0 <ami>"
  exit 1
fi

touch env
aws s3 cp env s3://memecaptain-secrets/env

aws s3 sync fonts s3://memecaptain-secrets/fonts

aws \
  cloudformation \
  update-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,UsePreviousValue=true" \
  "ParameterKey=dbPassword,UsePreviousValue=true" \
  "ParameterKey=canaryAmi,ParameterValue=$AMI" \
  "ParameterKey=onDemandAmi,UsePreviousValue=true" \
  "ParameterKey=spotAmi,UsePreviousValue=true"

wait_for_update "$STACK_NAME" "updating canary AMI to $AMI"

wait_for_pool_healthy canary

aws \
  cloudformation \
  update-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,UsePreviousValue=true" \
  "ParameterKey=dbPassword,UsePreviousValue=true" \
  "ParameterKey=canaryAmi,UsePreviousValue=true" \
  "ParameterKey=onDemandAmi,ParameterValue=$AMI" \
  "ParameterKey=spotAmi,UsePreviousValue=true"

wait_for_update "$STACK_NAME" "updating ondemand AMI to $AMI"

wait_for_pool_healthy ondemand

aws \
  cloudformation \
  update-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,UsePreviousValue=true" \
  "ParameterKey=dbPassword,UsePreviousValue=true" \
  "ParameterKey=canaryAmi,UsePreviousValue=true" \
  "ParameterKey=onDemandAmi,UsePreviousValue=true" \
  "ParameterKey=spotAmi,ParameterValue=$AMI"

wait_for_update "$STACK_NAME" "updating spot AMI to $AMI"

wait_for_pool_healthy spot
