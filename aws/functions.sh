wait_for_all_healthy() {
  while true; do
    ALL_HEALTHY=`aws elb describe-instance-health --load-balancer-name memecaptain | jq '.InstanceStates | map(.State=="InService") | all'`
    echo `date` all instances healthy? $ALL_HEALTHY
    if [ "$ALL_HEALTHY" = "true" ]; then break; fi
  done
}
