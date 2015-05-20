#!/bin/bash

if [ "$DB" = "database.yml.mysql" ]; then
  echo "gem 'mysql2'" >> Gemfile
  bundle
fi
