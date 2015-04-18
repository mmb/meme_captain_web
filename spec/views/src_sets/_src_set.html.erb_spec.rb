# encoding: UTF-8

require 'rails_helper'

describe 'src_sets/_src_set.html', type: :view do

  let(:src_thumb) { mock_model(SrcThumb, width: 19, height: 78) }

  let(:src_image) do
    mock_model(SrcImage, work_in_progress: false, src_thumb: src_thumb)
  end

  let(:src_set) do
    mock_model(SrcSet,
               name: 'set1',
               src_images: [src_image],
               thumbnail: src_thumb,
               thumb_width: src_thumb.width,
               thumb_height: src_thumb.height)
  end

  context 'when the set contains a completed source image' do

    it 'shows the thumbnail' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to match(src_thumb.id.to_s)
    end

    it 'puts the width in the image tag' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to match('width="19"')
    end

    it 'puts the height in the image tag' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to match('height="78"')
    end

  end

  context 'when the set is empty' do
    let(:src_set) do
      mock_model(SrcSet, name: 'set1', thumbnail: nil, src_images: [])
    end

    it 'shows the empty set' do
      render partial: 'src_sets/src_set', locals: { src_set: src_set }
      expect(rendered).to match(/class="empty-set"/)
    end

  end

  context 'when the set contains only under construction images' do
    it 'shows a default thumbnail'
  end

  it 'links to the source set' do
    render partial: 'src_sets/src_set', locals: { src_set: src_set }
    expect(rendered).to match(%r{href=".+\/#{src_set.name}"})
  end

end
