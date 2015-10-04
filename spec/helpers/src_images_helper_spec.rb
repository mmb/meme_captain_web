# encoding: UTF-8

require 'rails_helper'

describe SrcImagesHelper, type: :helper do
  let(:src_image) { FactoryGirl.create(:src_image) }

  describe '#src_image_url_for' do
    let(:host) { 'cdn.com' }

    before do
      src_image.set_derived_image_fields
      src_image.save!
    end

    it 'generates the src image url' do
      expected = "http://#{controller.request.host}/src_images/" \
          "#{src_image.id_hash}.#{src_image.format}"

      expect(helper.src_image_url_for(src_image)).to eq(expected)
    end

    it 'uses the src image host from the config if set' do
      stub_const 'MemeCaptainWeb::Config::GEND_IMAGE_HOST', host

      expected = "http://#{host}/src_images/" \
          "#{src_image.id_hash}.#{src_image.format}"

      expect(helper.src_image_url_for(src_image)).to eq(expected)
    end
  end

  describe '#meme_create_url' do
    it 'generates a url to create a meme with this src image' do
      expect(helper.meme_create_url(src_image)).to eq(
        "http://test.host/gend_images/new?src=#{src_image.id_hash}")
    end
  end
end
