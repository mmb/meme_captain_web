# encoding: UTF-8

require 'rails_helper'

describe 'src_sets/_src_set.html', type: :view do
  let(:src_image) { FactoryGirl.create(:finished_src_image) }
  let(:src_set) { FactoryGirl.create(:src_set, src_images: [src_image]) }

  context 'when the set contains a completed source image' do
    it 'shows the thumbnail' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to have_selector(
        "img[src='/src_thumbs/#{src_image.src_thumb.id}" \
	".#{src_image.src_thumb.format}']"
      )
    end

    it 'puts the width in the image tag' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to match('width="64"')
    end

    it 'puts the height in the image tag' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to match('height="64"')
    end

    it 'sets the image alt tag to the src image name ' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to have_selector(
        "img[src='/src_thumbs/#{src_image.src_thumb.id}" \
	".#{src_image.src_thumb.format}'][alt='#{src_set.name}']"
      )
    end
  end

  context 'when the set is empty' do
    let(:src_set) { FactoryGirl.create(:src_set) }

    it 'shows the empty set' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to match(/class="empty-set"/)
    end
  end

  it 'links to the source set' do
    render partial: 'src_sets/src_set', locals: { src_set: src_set }
    expect(rendered).to match(%r{href=".+\/#{src_set.name}"})
  end
end
