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
    # rubocop:disable Metrics/LineLength
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
    test_endpoint
)

STATUS_URL=$(echo $CREATE_RESPONSE | jq --raw-output .status_url)

i=0
while true; do
  if [ "$i" -ge 10 ]; then exit 1; fi
  case $(curl --head --output /dev/null --write-out '%{http_code}' $STATUS_URL) in
    303) curl --location --remote-name --verbose $STATUS_URL; break;;
    200) sleep 3;;
    *) exit 1
  esac
  i=$(( $i + 1 ))
done
EXPECTED
    # rubocop:enable Metrics/LineLength

    expect(render).to eq(expected_script)
  end
end
