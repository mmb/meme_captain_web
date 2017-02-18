require 'rails_helper'

describe 'MemeCaptainWeb::GendImageApiRequestJson' do
  describe '#json' do
    let(:src_image) { FactoryGirl.create(:src_image) }

    let(:caption1) do
      FactoryGirl.create(
        :caption,
        text: 'caption 1',
        top_left_x_pct: 1.0,
        top_left_y_pct: 2.0,
        width_pct: 3.0,
        height_pct: 4.0
      )
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
          private: false
        )
      end

      let(:caption2) do
        FactoryGirl.create(
          :caption,
          text: 'caption 2',
          top_left_x_pct: 5.0,
          top_left_y_pct: 6.0,
          width_pct: 7.0,
          height_pct: 8.0
        )
      end

      it 'sets private to false in the API input JSON' do
        expected_json = <<-EXPECTED_JSON.chomp
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
EXPECTED_JSON
        expect(
          MemeCaptainWeb::GendImageApiRequestJson.new(gend_image).json
        )
          .to eq(expected_json)
      end
    end

    context 'when the gend image is private' do
      let(:gend_image) do
        FactoryGirl.create(
          :gend_image,
          src_image: src_image,
          captions: [caption1],
          private: true
        )
      end

      it 'sets private to true in the API input JSON' do
        expected_json = <<-EXPECTED_JSON.chomp
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
EXPECTED_JSON
        expect(
          MemeCaptainWeb::GendImageApiRequestJson.new(gend_image).json
        )
          .to eq(expected_json.strip)
      end
    end
  end
end
