# encoding: UTF-8

require 'rails_helper'

describe 'gend_images/_gend_images.html', type: :view do
  let(:gend_images) { Kaminari.paginate_array([]).page(1) }

  context 'when toolbar is enabled' do
    let(:show_toolbar) { true }

    it 'shows the toolbar' do
      render(partial: 'gend_images/gend_images',
             locals: { gend_images: gend_images, show_toolbar: show_toolbar })

      expect(rendered).to have_selector '.btn-toolbar'
    end
  end

  context 'when the toolbar is disabled' do
    let(:show_toolbar) { false }

    it 'does not show the toolbar' do
      render(partial: 'gend_images/gend_images',
             locals: { gend_images: gend_images, show_toolbar: show_toolbar })

      expect(rendered).to_not have_selector '.btn-toolbar'
    end
  end
end
