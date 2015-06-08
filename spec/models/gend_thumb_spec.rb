# encoding: UTF-8

describe GendThumb do
  it { should validate_presence_of :content_type }

  it { should validate_presence_of :height }

  it { should validate_presence_of :image }

  it { should validate_presence_of :size }

  it { should validate_presence_of :width }

  it { should belong_to :gend_image }

  context 'setting fields derived from the image' do
    subject(:gend_thumb) do
      gend_thumb = GendThumb.new(FactoryGirl.attributes_for(:gend_thumb))
      gend_thumb.valid?
      gend_thumb
    end

    specify { expect(gend_thumb.content_type).to eq('image/png') }
    specify { expect(gend_thumb.height).to eq(50) }
    specify { expect(gend_thumb.width).to eq(460) }
    specify { expect(gend_thumb.size).to eq(279) }
  end
end
