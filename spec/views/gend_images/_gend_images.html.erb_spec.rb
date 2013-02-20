require 'spec_helper'

describe 'gend_images/_gend_images.html' do

  let(:user) { FactoryGirl.create(:user) }
  let(:gend_images) { Kaminari.paginate_array([]).page(1) }

  subject {
    render :partial => 'gend_images/gend_images',
           :locals => {:current_user => user}
  }

  context 'when the user is logged in' do

    it 'shows the toolbar' do
      assign :gend_images, gend_images
      subject

      expect(rendered).to have_selector '.btn-toolbar'
    end

  end

  context 'when the user is not logged in' do

    let(:user) { nil }

    it 'does not show the toolbar' do
      assign :gend_images, gend_images
      subject

      expect(rendered).to_not have_selector '.btn-toolbar'
    end

  end

end
