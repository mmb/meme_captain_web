# encoding: UTF-8

require 'spec_helper'

describe 'src_images/_src_image.html' do
  let(:src_thumb) { mock_model(SrcThumb, width: 19, height: 78) }
  let(:src_image) do
    mock_model(SrcImage, work_in_progress: false, src_thumb: src_thumb)
  end
  let(:user) { FactoryGirl.create(:user) }

  before do
    allow(view).to receive(:current_user).with(no_args).and_return(user)

    render partial: 'src_images/src_image',
           locals: { src_image: src_image }
  end

  context 'the image has been processed' do

    it 'shows the thumbnail' do
      expect(rendered).to match(src_thumb.id.to_s)
    end

    it 'puts the width in the image tag' do
      expect(rendered).to match('width="19"')
    end

    it 'puts the height in the image tag' do
      expect(rendered).to match('height="78"')
    end

    it 'has the id hash as data' do
      expect(rendered).to match("data-id=\"#{src_image.id_hash}\"")
    end

  end

  context 'the image has not been processed yet' do

    let(:src_image) { mock_model(SrcImage, work_in_progress: true) }

    it 'shows as under construction' do
      expect(rendered).to match('Under Construction')
    end

  end

  context 'when the user is logged in' do
    it 'shows the checkbox' do
      expect(rendered).to have_selector '.selector'
    end

  end

  context 'when the user is not logged in' do
    let(:user) { nil }

    it 'hides the checkbox' do
      expect(rendered).to_not have_selector '.selector'
    end

  end

end
