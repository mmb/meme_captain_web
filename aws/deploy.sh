#!/bin/bash

set -e

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

while true; do
  STATUS=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq --raw-output .Stacks[0].StackStatus`
  echo `date` killing canary status $STATUS

  if [[ "$STATUS" == UPDATE_COMPLETE* ]]; then break; fi
  if [ "$STATUS" != "UPDATE_IN_PROGRESS" ]; then
    exit 1
  fi

  sleep 4
done

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

while true; do
  STATUS=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq --raw-output .Stacks[0].StackStatus`
  echo `date` reviving canary status $STATUS

  if [[ "$STATUS" == UPDATE_COMPLETE* ]]; then break; fi
  if [ "$STATUS" != "UPDATE_IN_PROGRESS" ]; then
    exit 1
  fi

  sleep 4
done

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

while true; do
  STATUS=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq --raw-output .Stacks[0].StackStatus`
  echo `date` killing on demand status $STATUS

  if [[ "$STATUS" == UPDATE_COMPLETE* ]]; then break; fi
  if [ "$STATUS" != "UPDATE_IN_PROGRESS" ]; then
    exit 1
  fi

  sleep 4
done

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

while true; do
  STATUS=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq --raw-output .Stacks[0].StackStatus`
  echo `date` reviving on demand status $STATUS

  if [[ "$STATUS" == UPDATE_COMPLETE* ]]; then break; fi
  if [ "$STATUS" != "UPDATE_IN_PROGRESS" ]; then
    exit 1
  fi

  sleep 4
done
