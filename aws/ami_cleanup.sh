#!/bin/bash

aws \
  ec2 \
  describe-images \
  --owners self \
  --filters 'Name=name,Values=memecaptain-*' \
  | \
  jq \
  --raw-output \
  '.Images | sort_by(.CreationDate) | reverse | .[3:-1][] | .ImageId+" "+.BlockDeviceMappings[0].Ebs.SnapshotId' \
  | \
  while read AMI_ID SNAPSHOT_ID; do
    echo "deregister AMI $AMI_ID"
    aws ec2 deregister-image --image-id $AMI_ID
    echo "delete snapshot $SNAPSHOT_ID"
    aws ec2 delete-snapshot --snapshot-id $SNAPSHOT_ID
  done
