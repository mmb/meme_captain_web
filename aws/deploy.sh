#!/bin/bash

set -e

source functions.sh

STACK_NAME=memecaptain
NUM_ON_DEMAND=1

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
  "ParameterKey=canaryMinSize,ParameterValue=0" \
  "ParameterKey=canaryMaxSize,ParameterValue=0" \
  "ParameterKey=onDemandMinSize,UsePreviousValue=true" \
  "ParameterKey=onDemandMaxSize,UsePreviousValue=true"

wait_for_update "$STACK_NAME" "killing canary"

aws \
  cloudformation \
  update-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,UsePreviousValue=true" \
  "ParameterKey=dbPassword,UsePreviousValue=true" \
  "ParameterKey=canaryMinSize,ParameterValue=1" \
  "ParameterKey=canaryMaxSize,ParameterValue=1" \
  "ParameterKey=onDemandMinSize,UsePreviousValue=true" \
  "ParameterKey=onDemandMaxSize,UsePreviousValue=true"

wait_for_update "$STACK_NAME" "reviving canary"

wait_for_all_healthy

aws \
  cloudformation \
  update-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,UsePreviousValue=true" \
  "ParameterKey=dbPassword,UsePreviousValue=true" \
  "ParameterKey=canaryMinSize,UsePreviousValue=true" \
  "ParameterKey=canaryMaxSize,UsePreviousValue=true" \
  "ParameterKey=onDemandMinSize,ParameterValue=0" \
  "ParameterKey=onDemandMaxSize,ParameterValue=0"

wait_for_update "$STACK_NAME" "killing ondemand"

aws \
  cloudformation \
  update-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,UsePreviousValue=true" \
  "ParameterKey=dbPassword,UsePreviousValue=true" \
  "ParameterKey=canaryMinSize,UsePreviousValue=true" \
  "ParameterKey=canaryMaxSize,UsePreviousValue=true" \
  "ParameterKey=onDemandMinSize,ParameterValue=$NUM_ON_DEMAND" \
  "ParameterKey=onDemandMaxSize,ParameterValue=$NUM_ON_DEMAND"

wait_for_update "$STACK_NAME" "reviving ondemand"

wait_for_all_healthy
