# encoding: UTF-8

require 'rails_helper'

describe SrcImagesHelper, type: :helper do
  describe '#src_image_url_for' do
    let(:host) { 'cdn.com' }
    let(:src_image) { FactoryGirl.create(:src_image) }

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

  describe '#src_thumb_url_for' do
    let(:src_image) { FactoryGirl.create(:finished_src_image) }

    it 'generates the src thumb url' do
      expected = "/src_thumbs/#{src_image.src_thumb.id}" \
        ".#{src_image.src_thumb.format}"

      expect(helper.src_thumb_url_for(src_image)).to eq(expected)
    end
  end
end
