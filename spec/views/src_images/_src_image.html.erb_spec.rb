require 'rails_helper'

require 'support/src_image_skip_callbacks'

describe 'src_images/_src_image.html', type: :view do
  let(:src_image) do
    FactoryGirl.create(:finished_src_image, name: 'test src image')
  end
  let(:user) { FactoryGirl.create(:user) }

  before do
    render partial: 'src_images/src_image',
           locals: { src_image: src_image, user: user }
  end

  context 'the image has been processed' do
    it 'shows the thumbnail' do
      expect(rendered).to have_selector(
        "img[src='/src_thumbs/#{src_image.src_thumb.id}" \
        ".#{src_image.src_thumb.format}']"
      )
    end

    it 'puts the width in the image tag' do
      expect(rendered).to match('width="64"')
    end

    it 'puts the height in the image tag' do
      expect(rendered).to match('height="64"')
    end

    it 'has the id hash as data' do
      expect(rendered).to match("data-id=\"#{src_image.id_hash}\"")
    end

    it 'sets the image alt tag to the src image name ' do
      expect(rendered).to have_selector(
        "img[src='/src_thumbs/#{src_image.src_thumb.id}" \
	".#{src_image.src_thumb.format}'][alt='test src image']"
      )
    end
  end

  context 'the image has not been processed yet' do
    let(:src_image) { FactoryGirl.create(:src_image) }

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
