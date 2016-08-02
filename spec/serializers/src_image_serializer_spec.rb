require 'rails_helper'

describe SrcImageSerializer do
  describe 'attributes' do
    it 'serializes the correct attributes' do
      expect(SrcImageSerializer._attributes).to eq(
        [
          :content_type,
          :created_at,
          :height,
          :id_hash,
          :image_url,
          :name,
          :size,
          :updated_at,
          :width
        ]
      )
    end
  end
end
