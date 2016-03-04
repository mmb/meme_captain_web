# encoding: UTF-8

require 'rails_helper'

describe 'gend_image_scripts/show.text.erb', type: :view do
  let(:gend_image) do
    FactoryGirl.create(:gend_image, work_in_progress: false)
  end

  before do
    assign(:endpoint, 'test_endpoint')
    assign(:json, 'test json')
  end

  it 'generates a script that can recreate the gend image using the API' do
    expected_script = <<-EXPECTED
#!/bin/bash

set -eu
set -o pipefail

REQUEST_JSON=$(cat << EOS
test json
EOS)

# To make an authenticated request add:
# --header "Authorization: Token token=\\"<your API token>\\""
CREATE_RESPONSE=$(
  echo "$REQUEST_JSON" | \\
  curl \\
    --data @- \\
    --header 'Content-Type: application/json' \\
    --header 'Accept: application/json' \\
    --fail \\
    test_endpoint
)

STATUS_URL=$(echo "$CREATE_RESPONSE" | jq --raw-output '.status_url')

i=0
while true; do
  RESPONSE=$(curl --fail $STATUS_URL)
  IN_PROGRESS=$(echo "$RESPONSE" | jq --raw-output '.in_progress')
  if [ "$IN_PROGRESS" = "false" ]; then
    ERROR=$(echo "$RESPONSE" | jq --raw-output '.error')
    if [ "$ERROR" = "null" ]; then
      echo "$RESPONSE" | jq --raw-output '.url'
      exit 0
    else
      echo "$ERROR"
      exit 1
    fi
  fi
  i=$(( $i + 1 ))
  if [ "$i" -ge 10 ]; then
    echo "$RESPONSE" | jq .
    exit 1
  fi
  sleep 3
done
EXPECTED

    expect(render).to eq(expected_script)
  end
end
