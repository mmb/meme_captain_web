require 'spec_helper'

describe 'gend_images/_gend_image.html' do
  let(:gend_thumb) { mock_model(GendThumb, width: 19, height: 80) }

  let(:gend_image) { mock_model(
      GendImage,
      work_in_progress: false,
      gend_thumb: gend_thumb,
      id_hash: 'id_hash') }

  let(:show_toolbar) { true }

  before do
    assign :show_toolbar, show_toolbar
  end

  subject {
    render partial: 'gend_images/gend_image', locals: { gend_image: gend_image }
  }

  context 'the image has been processed' do

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

    let(:gend_image) { mock_model(GendImage, work_in_progress: true) }

    it 'shows as under construction' do
      subject
      expect(rendered).to match('Under Construction')
    end

  end

  context 'when the toolbar is enabled' do
    it 'shows the checkbox' do
      subject

      expect(rendered).to have_selector '.selector'
    end
  end

  context 'when the toolbar is disabled' do
    let(:show_toolbar) { false }

    it 'hides the checkbox' do
      subject

      expect(rendered).to_not have_selector '.selector'
    end
  end

end
