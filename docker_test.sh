#!/bin/bash

set -e
set -o pipefail

docker build -t meme_captain_test .

docker run \
  -d \
  -e RAILS_ENV=production \
  -e SECRET_KEY_BASE=secret \
  --name=meme_captain_test \
  -p 6081:6081 \
  --privileged=true \
  meme_captain_test

docker exec meme_captain_test rake db:migrate

IP=$(echo $DOCKER_HOST | tr -c -d [:digit:].: | cut -d : -f 2)

curl $IP:6081

# cucumber

docker stop meme_captain_test
