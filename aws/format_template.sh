#!/bin/bash

set -e

jq --sort-keys . < meme_captain.json > meme_captain.json.new

mv meme_captain.json{.new,}
