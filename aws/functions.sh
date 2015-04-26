wait_for_all_healthy() {
  while true; do
    ALL_HEALTHY=`aws elb describe-instance-health --load-balancer-name memecaptain | jq '.InstanceStates | map(.State=="InService") | all'`
    echo `date` all instances healthy? $ALL_HEALTHY
    if [ "$ALL_HEALTHY" = "true" ]; then break; fi
    sleep 4
  done
}

wait_for_update() {
  STACK_NAME="$1"
  MESSAGE="$2"

  while true; do
    STATUS=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq --raw-output .Stacks[0].StackStatus`
    echo "`date` $MESSAGE $STATUS"

    if [[ "$STATUS" == UPDATE_COMPLETE* ]]; then break; fi
    if [ "$STATUS" != "UPDATE_IN_PROGRESS" ]; then
      exit 1
    fi

    sleep 4
  done
}
