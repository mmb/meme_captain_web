#!/bin/bash

set -e

aws \
  cloudformation \
  create-stack \
  --stack-name memecaptain \
  --template-body file://meme_captain.json \
  --parameters \
  "ParameterKey=dbUser,ParameterValue=$1" \
  "ParameterKey=dbPassword,ParameterValue=$2"
