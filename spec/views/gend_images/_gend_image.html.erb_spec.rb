require 'spec_helper'

describe 'gend_images/_gend_image.html' do

  subject {
    render :partial => 'gend_images/gend_image',
           :locals => {:gend_image => gend_image}
  }

  context 'the image has been processed' do
    let(:gend_thumb) { mock_model(GendThumb, :width => 19, :height => 80) }
    let(:gend_image) { mock_model(GendImage,
                                  :work_in_progress => false,
                                  :gend_thumb => gend_thumb,
                                  :id_hash => 'id_hash') }

    it 'shows the thumbnail' do
      subject
      expect(rendered).to match(gend_thumb.id.to_s)
    end

    it 'puts the width in the image tag' do
      subject
      expect(rendered).to match('width="19"')
    end

    it 'puts the height in the image tag' do
      subject
      expect(rendered).to match('height="80"')
    end

    it 'has the id hash as data' do
      subject
      expect(rendered).to match("data-id=\"#{gend_image.id_hash}\"")
    end

  end

  context 'the image has not been processed yet' do

    let(:gend_image) { mock_model(GendImage, :work_in_progress => true) }

    it 'shows as under construction' do
      subject
      expect(rendered).to match('Under Construction')
    end

  end

end
