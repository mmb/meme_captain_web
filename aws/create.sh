#!/bin/bash

set -e

source functions.sh

STACK_NAME=memecaptain
DB_USER=memecaptain
DB_PASSWORD=`ha-gen -l 31 -d-`

aws \
  cloudformation \
  create-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,ParameterValue=$DB_USER" \
  "ParameterKey=dbPassword,ParameterValue=$DB_PASSWORD" \
  "ParameterKey=canaryMinSize,ParameterValue=0" \
  "ParameterKey=canaryMaxSize,ParameterValue=0" \
  "ParameterKey=onDemandMinSize,ParameterValue=0" \
  "ParameterKey=onDemandMaxSize,ParameterValue=0" \
  "ParameterKey=spotMinSize,ParameterValue=0" \
  "ParameterKey=spotMaxSize,ParameterValue=0"

while true; do
  STATUS=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq --raw-output .Stacks[0].StackStatus`
  echo `date` stack create status $STATUS

  if [ "$STATUS" = "CREATE_COMPLETE" ]; then break; fi
  if [ "$STATUS" != "CREATE_IN_PROGRESS" ]; then
    exit 1
  fi

  sleep 4
done

DB_HOST=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq --raw-output '.Stacks[0].Outputs | map(select(.OutputKey=="dbHost"))[0].OutputValue'`

cat << EOF > database.yml
production:
  adapter: postgresql
  username: "$DB_USER"
  password: "$DB_PASSWORD"
  database: memecaptain
  host: $DB_HOST
EOF

aws s3 cp database.yml s3://memecaptain-secrets/database.yml

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
  "ParameterKey=dbUser,ParameterValue=$DB_USER" \
  "ParameterKey=dbPassword,ParameterValue=$DB_PASSWORD" \
  "ParameterKey=canaryMinSize,ParameterValue=1" \
  "ParameterKey=canaryMaxSize,ParameterValue=1" \
  "ParameterKey=onDemandMinSize,ParameterValue=0" \
  "ParameterKey=onDemandMaxSize,ParameterValue=0" \
  "ParameterKey=spotMinSize,ParameterValue=0" \
  "ParameterKey=spotMaxSize,ParameterValue=0"

wait_for_update "$STACK_NAME" "canary create"

wait_for_all_healthy

aws \
  cloudformation \
  update-stack \
  --stack-name $STACK_NAME \
  --template-body file://meme_captain.json \
  --capabilities CAPABILITY_IAM \
  --parameters \
  "ParameterKey=dbUser,ParameterValue=$DB_USER" \
  "ParameterKey=dbPassword,ParameterValue=$DB_PASSWORD" \
  "ParameterKey=canaryMinSize,ParameterValue=1" \
  "ParameterKey=canaryMaxSize,ParameterValue=1" \
  "ParameterKey=onDemandMinSize,ParameterValue=1" \
  "ParameterKey=onDemandMaxSize,ParameterValue=1" \
  "ParameterKey=spotMinSize,ParameterValue=1" \
  "ParameterKey=spotMaxSize,ParameterValue=3"

wait_for_update "$STACK_NAME" "ondemand and spot create"

wait_for_all_healthy
