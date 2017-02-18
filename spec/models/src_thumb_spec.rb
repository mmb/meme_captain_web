require 'rails_helper'

describe SrcThumb do
  it { should validate_presence_of :content_type }

  it { should validate_presence_of :height }

  it { should validate_presence_of :image }

  it { should validate_presence_of :size }

  it { should validate_presence_of :width }

  it { should belong_to :src_image }

  context 'setting fields derived from the image' do
    subject(:src_thumb) do
      src_thumb = SrcThumb.new(FactoryGirl.attributes_for(:src_thumb))
      src_thumb.valid?
      src_thumb
    end

    specify { expect(src_thumb.content_type).to eq('image/png') }
    specify { expect(src_thumb.height).to eq(50) }
    specify { expect(src_thumb.width).to eq(460) }
    specify { expect(src_thumb.size).to eq(279) }
  end

  describe '#dimensions' do
    it 'returns widthxheight' do
      src_thumb = FactoryGirl.create(:src_thumb)
      expect(src_thumb.dimensions).to eq('460x50')
    end
  end
end
