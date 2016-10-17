require 'rails_helper'

describe 'list src images using the JSON API', type: :request do
  it 'lists src images' do
    src_image = FactoryGirl.create(:src_image, work_in_progress: false)
    src_image.set_derived_image_fields
    src_image.save!
    src_image.reload

    get(
      '/api/v3/src_images',
      headers: {
        'Accept' => 'application/json'
      }
    )

    expect(JSON.parse(response.body)).to eq(
      [
        {
          'id_hash' => src_image.id_hash,
          'width' => 399,
          'height' => 399,
          'size' => 9141,
          'content_type' => 'image/jpeg',
          'created_at' =>
    src_image.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
          'updated_at' =>
    src_image.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
          'name' => 'src image name',
          'image_url' =>
          "http://www.example.com/src_images/#{src_image.id_hash}.jpg"
        }
      ]
    )
  end
end
