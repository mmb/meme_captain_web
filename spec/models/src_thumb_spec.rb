require 'spec_helper'

describe SrcThumb do

  let(:test_image) {
    Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAcwAAAAyAgMAAACsWgPIAAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wBHwQoJY1iyrwAAAAJUExURQAAAAAAAP///4Pdz9IAAAABdFJOUwBA5thmAAAAAWJLR0QB/wIt3gAAAHpJREFUWIXt1zESgCAMRNE03s9mG+9ns6e0EaKCqDOWf4sUJOHREvqciOn7Us0cEZiYmJhnc7HtVbJtS5LsVRo09DScZzmSG5iYmJit2RTVlduGquS920hFvxRMTEzMRzOv6TfKheMX9ThMTEzMnvlj5ld/S0xMTMxjNoGjc3pdi6L4AAAAAElFTkSuQmCC')
  }

  it { should validate_presence_of :content_type }
  it { should allow_mass_assignment_of :content_type }

  it { should validate_presence_of :height }
  it { should allow_mass_assignment_of :height }

  it { should validate_presence_of :image }
  it { should allow_mass_assignment_of :image }

  it { should validate_presence_of :size }
  it { should allow_mass_assignment_of :size }

  it { should validate_presence_of :width }
  it { should allow_mass_assignment_of :width }

  it { should belong_to :src_image }

  context 'setting fields derived from the image' do

    subject {
      src_thumb = SrcThumb.new(:image => test_image)
      src_thumb.valid?
      src_thumb
    }

    its(:content_type) { should == 'image/png' }
    its(:height) { should == 50 }
    its(:width) { should == 460 }
    its(:size) { should == 279 }
  end

end
