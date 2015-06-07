require 'rails_helper'

describe 'creating a gend image using the JSON API', type: :request do
  it 'creates a new gend image in the database' do
    src_image = FactoryGirl.create(:src_image)

    request_body = {
      src_image_id: src_image.id_hash,
      private: true,
      captions_attributes: [
        {
          text: 'top text',
          top_left_x_pct: 0.05,
          top_left_y_pct: 0.0,
          width_pct: 0.9,
          height_pct: 0.25
        }, {
          text: 'bottom text',
          top_left_x_pct: 0.05,
          top_left_y_pct: 0.75,
          width_pct: 0.9,
          height_pct: 0.25
        }
      ]
    }.to_json

    post(
      '/gend_images',
      request_body,
      'CONTENT_TYPE' => 'application/json',
      'HTTP_ACCEPT' => 'application/json')

    created_gend_image = GendImage.last
    expect(created_gend_image.src_image).to eq(src_image)
    expect(created_gend_image.private).to be(true)

    caption1 = created_gend_image.captions[0]
    expect(caption1.text).to eq('top text')
    expect(caption1.top_left_x_pct).to eq(0.05)
    expect(caption1.top_left_y_pct).to eq(0.0)
    expect(caption1.width_pct).to eq(0.9)
    expect(caption1.height_pct).to eq(0.25)

    caption2 = created_gend_image.captions[1]
    expect(caption2.text).to eq('bottom text')
    expect(caption2.top_left_x_pct).to eq(0.05)
    expect(caption2.top_left_y_pct).to eq(0.75)
    expect(caption2.width_pct).to eq(0.9)
    expect(caption2.height_pct).to eq(0.25)
  end
end
