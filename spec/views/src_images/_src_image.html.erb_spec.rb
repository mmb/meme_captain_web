require 'spec_helper'

describe 'src_images/_src_image.html' do

  subject {
    render :partial => 'src_images/src_image',
           :locals => {:src_image => src_image}
  }

  context 'the image has been processed' do
    let(:src_thumb) { mock_model(SrcThumb) }
    let(:src_image) { mock_model(SrcImage,
                                 :work_in_progress => false,
                                 :src_thumb => src_thumb) }

    it 'shows the thumbnail' do
      subject
      expect(rendered).to match(src_thumb.id.to_s)
    end

  end

  context 'the image has not been processed yet' do

    let(:src_image) { mock_model(SrcImage, :work_in_progress => true) }

    it 'shows the under construction image' do
      subject
      expect(rendered).to match('under_construction')
    end

  end

end
