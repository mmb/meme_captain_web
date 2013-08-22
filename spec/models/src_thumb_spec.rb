require 'spec_helper'

describe SrcThumb do

  it { should validate_presence_of :content_type }

  it { should validate_presence_of :height }

  it { should validate_presence_of :image }

  it { should validate_presence_of :size }

  it { should validate_presence_of :width }

  it { should belong_to :src_image }

  context 'setting fields derived from the image' do

    subject {
      src_thumb = SrcThumb.new(FactoryGirl.attributes_for(:src_thumb))
      src_thumb.valid?
      src_thumb
    }

    its(:content_type) { should == 'image/png' }
    its(:height) { should == 50 }
    its(:width) { should == 460 }
    its(:size) { should == 279 }
  end

end
