require 'rails_helper'

describe GendImageSerializer do
  describe 'attributes' do
    it 'serializes the correct attributes' do
      expect(GendImageSerializer._attributes).to eq(
        %i[
          content_type
          created_at
          height
          image_url
          size
          thumbnail_url
          updated_at
          width
        ]
      )
    end

    it 'includes captions' do
      expect(GendImageSerializer._reflections).to include(
        captions: ActiveModel::Serializer::HasManyReflection.new(:captions, {})
      )
    end
  end
end
