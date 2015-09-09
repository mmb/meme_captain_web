#!/bin/bash

if [ "$DB" = "database.yml.mysql" ]; then
  echo "gem 'mysql2', '~> 0.4.0'" >> Gemfile
  bundle
fi
