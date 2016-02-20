require 'rails_helper'

describe 'MemeCaptainWeb::GoogleImageNamer' do
  subject(:google_image_namer) { MemeCaptainWeb::GoogleImageNamer.new }

  describe '#name' do
    it 'does a Google image search for the image by url' do
      expect(google_image_namer.name(
               'https://upload.wikimedia.org/wikipedia/commons/3/37/Bucketheadgnr.jpg'))
        .to eq('buckethead without mask')
    end
  end
end
