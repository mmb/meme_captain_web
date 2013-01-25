require 'spec_helper'

describe 'src_images/_src_image.html' do

  subject {
    render :partial => 'src_images/src_image',
           :locals => {:src_image => src_image}
  }

  context 'the image has been processed' do
    let(:src_thumb) { mock_model(SrcThumb, :width => 19, :height => 78) }
    let(:src_image) { mock_model(SrcImage,
                                 :work_in_progress => false,
                                 :src_thumb => src_thumb) }

    it 'shows the thumbnail' do
      subject
      expect(rendered).to match(src_thumb.id.to_s)
    end

    it 'puts the width in the image tag' do
      subject
      expect(rendered).to match('width="19"')
    end

    it 'puts the height in the image tag' do
      subject
      expect(rendered).to match('height="78"')
    end

    it 'has the id hash as data' do
      subject
      expect(rendered).to match("data-id=\"#{src_image.id_hash}\"")
    end

  end

  context 'the image has not been processed yet' do

    let(:src_image) { mock_model(SrcImage, :work_in_progress => true) }

    it 'shows as under construction' do
      subject
      expect(rendered).to match('Under Construction')
    end

  end

end
