#!/bin/bash

set -e

for JSON in *.json; do
  echo $JSON
  jq --sort-keys . < $JSON > $JSON.new

  mv $JSON{.new,}
done
