require 'rails_helper'

describe GendImageSerializer do
  describe 'attributes' do
    it 'serializes the correct attributes' do
      expect(GendImageSerializer._attributes).to eq(
        [
          :image_url,
          :thumbnail_url
        ]
      )
    end

    it 'includes captions' do
      expect(GendImageSerializer._reflections).to include(
        ActiveModel::Serializer::HasManyReflection.new(:captions, {})
      )
    end
  end
end
