require 'rails_helper'

require 'support/gend_image_skip_callbacks'

describe GendImagesHelper, type: :helper do
  describe '#gend_image_url_for' do
    let(:host) { 'cdn.com' }
    let(:gend_image) { FactoryGirl.create(:gend_image) }

    it 'generates the gend image url' do
      expected = "http://#{controller.request.host}/gend_images/" \
          "#{gend_image.id_hash}.#{gend_image.format}"

      expect(helper.gend_image_url_for(gend_image)).to eq(expected)
    end

    it 'uses the gend image host from the config if set' do
      stub_const 'MemeCaptainWeb::Config::GEND_IMAGE_HOST', host

      expected = "http://#{host}/gend_images/" \
          "#{gend_image.id_hash}.#{gend_image.format}"

      expect(helper.gend_image_url_for(gend_image)).to eq(expected)
    end
  end

  describe '#gend_thumb_url_for' do
    let(:gend_image) { FactoryGirl.create(:finished_gend_image) }

    it 'generates the gend thumb url' do
      expected = "/gend_thumbs/#{gend_image.gend_thumb.id}" \
        ".#{gend_image.gend_thumb.format}"

      expect(helper.gend_thumb_url_for(gend_image)).to eq(expected)
    end
  end
end
