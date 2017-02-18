require 'rails_helper'

require 'support/gend_image_skip_callbacks'

describe 'gend_images/_gend_image.html', type: :view do
  let(:gend_image) { FactoryGirl.create(:finished_gend_image) }
  let(:show_toolbar) { true }

  before do
    assign :show_toolbar, show_toolbar
  end

  context 'the image has been processed' do
    it 'shows the thumbnail' do
      render partial: 'gend_images/gend_image',
             locals: { gend_image: gend_image, show_toolbar: show_toolbar }
      expect(rendered).to have_selector(
        "img[src='/gend_thumbs/#{gend_image.gend_thumb.id}" \
        ".#{gend_image.gend_thumb.format}']"
      )
    end

    it 'puts the width in the image tag' do
      render partial: 'gend_images/gend_image',
             locals: { gend_image: gend_image, show_toolbar: show_toolbar }
      expect(rendered).to match('width="64"')
    end

    it 'puts the height in the image tag' do
      render partial: 'gend_images/gend_image',
             locals: { gend_image: gend_image, show_toolbar: show_toolbar }
      expect(rendered).to match('height="64"')
    end

    it 'has the id hash as data' do
      render partial: 'gend_images/gend_image',
             locals: { gend_image: gend_image, show_toolbar: show_toolbar }
      expect(rendered).to match("data-id=\"#{gend_image.id_hash}\"")
    end
  end

  context 'the image has not been processed yet' do
    let(:gend_image) { FactoryGirl.create(:gend_image) }

    it 'shows as under construction' do
      render partial: 'gend_images/gend_image',
             locals: { gend_image: gend_image, show_toolbar: show_toolbar }
      expect(rendered).to match('Under Construction')
    end
  end

  context 'when the toolbar is enabled' do
    it 'shows the checkbox' do
      render partial: 'gend_images/gend_image',
             locals: { gend_image: gend_image, show_toolbar: show_toolbar }

      expect(rendered).to have_selector '.selector'
    end
  end

  context 'when the toolbar is disabled' do
    let(:show_toolbar) { false }

    it 'hides the checkbox' do
      render partial: 'gend_images/gend_image',
             locals: { gend_image: gend_image, show_toolbar: show_toolbar }

      expect(rendered).to_not have_selector '.selector'
    end
  end
end
