#!/bin/bash

set -e

source functions.sh

AMI="$1"

if [ -z "$AMI" ]; then
  echo "Usage: $0 <ami>"
  exit 1
fi

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
  "ParameterKey=canaryAmi,ParameterValue=ami-1ecae776" \
  "ParameterKey=onDemandAmi,ParameterValue=ami-1ecae776" \
  "ParameterKey=spotAmi,ParameterValue=ami-1ecae776"

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
  pool: <%= ENV['DB_POOL'] || 5 %>
EOF

aws s3 cp database.yml s3://memecaptain-secrets/database.yml

./deploy.sh "$AMI"
