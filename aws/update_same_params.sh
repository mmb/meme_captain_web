#!/bin/bash

set -e

STACK_NAME=memecaptain

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
  "ParameterKey=spotAmi,UsePreviousValue=true"
