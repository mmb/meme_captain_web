require 'spec_helper'

describe GendImagesHelper do

  describe '#gend_image_url_for' do

    let(:host) { 'cdn.com' }
    let(:gend_image) { FactoryGirl.create(:gend_image) }

    it 'generates the gend image url' do
      expect(helper.gend_image_url_for(gend_image)).to eq "http://#{controller.request.host}/gend_images/#{gend_image.id_hash}.#{gend_image.format}"
    end

    it 'uses the gend image host from the config if set' do
      stub_const 'MemeCaptainWeb::Config::GendImageHost', host

      expect(helper.gend_image_url_for(gend_image)).to eq "http://#{host}/gend_images/#{gend_image.id_hash}.#{gend_image.format}"
    end

  end

end
