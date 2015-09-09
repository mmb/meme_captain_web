#!/bin/bash

if [ "$DB" = "database.yml.mysql" ]; then
  echo "gem 'mysql2', '~> 0.3.13'" >> Gemfile
  bundle
fi
