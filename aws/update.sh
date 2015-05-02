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
  "ParameterKey=canaryMinSize,UsePreviousValue=true" \
  "ParameterKey=canaryMaxSize,UsePreviousValue=true" \
  "ParameterKey=onDemandMinSize,UsePreviousValue=true" \
  "ParameterKey=onDemandMaxSize,UsePreviousValue=true" \
  "ParameterKey=spotMinSize,UsePreviousValue=true" \
  "ParameterKey=spotMaxSize,UsePreviousValue=true"
