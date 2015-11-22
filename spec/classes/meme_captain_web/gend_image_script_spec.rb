# encoding: UTF-8

require 'rails_helper'

describe 'MemeCaptainWeb::GendImageScript' do
  describe '#script' do
    let(:src_image) { FactoryGirl.create(:src_image) }

    let(:caption1) do
      FactoryGirl.create(
        :caption,
        text: 'caption 1',
        top_left_x_pct: 1.0,
        top_left_y_pct: 2.0,
        width_pct: 3.0,
        height_pct: 4.0)
    end

    before do
      src_image.update_attribute(:id_hash, 'abcde')
    end

    context 'when the gend image is not private' do
      let(:gend_image) do
        FactoryGirl.create(
          :gend_image,
          src_image: src_image,
          captions: [caption1, caption2],
          private: false)
      end

      let(:caption2) do
        FactoryGirl.create(
          :caption,
          text: 'caption 2',
          top_left_x_pct: 5.0,
          top_left_y_pct: 6.0,
          width_pct: 7.0,
          height_pct: 8.0)
      end

      it 'sets private to false in the API input JSON' do
        # rubocop:disable Metrics/LineLength
        expected_output = <<-EXPECTED
# shell script to recreate this image using the API
# add -H 'Authorization: Token token="<your API token>"' to use an API token
STATUS_URL=$(cat << EOS | curl -d @- -H 'Content-Type: application/json' -H 'Accept: application/json' -s http://testhost.com/gend_images | jq -r .status_url
{
  "private": false,
  "src_image_id": "abcde",
  "captions_attributes": [
    {
      "text": "caption 1",
      "top_left_x_pct": 1.0,
      "top_left_y_pct": 2.0,
      "width_pct": 3.0,
      "height_pct": 4.0
    },
    {
      "text": "caption 2",
      "top_left_x_pct": 5.0,
      "top_left_y_pct": 6.0,
      "width_pct": 7.0,
      "height_pct": 8.0
    }
  ]
}
EOS)
for i in $(seq 10); do
  case $(curl -I -o /dev/null -s -w '%{http_code}' $STATUS_URL) in
    303) curl -L -s $STATUS_URL; break;;
    200) sleep 3;;
    *) exit 1
  esac
done
EXPECTED
        # rubocop:enable Metrics/LineLength
        expect(
          MemeCaptainWeb::GendImageScript.new(
            gend_image, 'http://testhost.com/gend_images').script)
          .to eq(expected_output)
      end
    end

    context 'when the gend image is private' do
      let(:gend_image) do
        FactoryGirl.create(
          :gend_image,
          src_image: src_image,
          captions: [caption1],
          private: true)
      end

      it 'sets private to true in the API input JSON' do
        # rubocop:disable Metrics/LineLength
        expected_output = <<-EXPECTED
# shell script to recreate this image using the API
# add -H 'Authorization: Token token="<your API token>"' to use an API token
STATUS_URL=$(cat << EOS | curl -d @- -H 'Content-Type: application/json' -H 'Accept: application/json' -s http://testhost.com/gend_images | jq -r .status_url
{
  "private": true,
  "src_image_id": "abcde",
  "captions_attributes": [
    {
      "text": "caption 1",
      "top_left_x_pct": 1.0,
      "top_left_y_pct": 2.0,
      "width_pct": 3.0,
      "height_pct": 4.0
    }
  ]
}
EOS)
for i in $(seq 10); do
  case $(curl -I -o /dev/null -s -w '%{http_code}' $STATUS_URL) in
    303) curl -L -s $STATUS_URL; break;;
    200) sleep 3;;
    *) exit 1
  esac
done
EXPECTED
        # rubocop:enable Metrics/LineLength
        expect(
          MemeCaptainWeb::GendImageScript.new(
            gend_image, 'http://testhost.com/gend_images').script)
          .to eq(expected_output)
      end
    end
  end
end
