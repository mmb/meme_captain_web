require 'base64'

require 'spec_helper'

describe SrcImage do

  let(:test_image) {
    Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAcwAAAAyAgMAAACsWgPIAAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wBHwQoJY1iyrwAAAAJUExURQAAAAAAAP///4Pdz9IAAAABdFJOUwBA5thmAAAAAWJLR0QB/wIt3gAAAHpJREFUWIXt1zESgCAMRNE03s9mG+9ns6e0EaKCqDOWf4sUJOHREvqciOn7Us0cEZiYmJhnc7HtVbJtS5LsVRo09DScZzmSG5iYmJit2RTVlduGquS920hFvxRMTEzMRzOv6TfKheMX9ThMTEzMnvlj5ld/S0xMTMxjNoGjc3pdi6L4AAAAAElFTkSuQmCC')
  }

  it { should validate_presence_of :content_type }
  it { should_not allow_mass_assignment_of :content_type }

  it { should validate_presence_of :height }
  it { should_not allow_mass_assignment_of :height }

  it { should_not allow_mass_assignment_of :id_hash }
  it { should validate_uniqueness_of :id_hash }

  it { should validate_presence_of :image }
  it { should allow_mass_assignment_of :image }

  it { should validate_presence_of :size }
  it { should_not allow_mass_assignment_of :size }

  it { should_not validate_presence_of :url }
  it { should allow_mass_assignment_of :url }

  it { should validate_presence_of :width }
  it { should_not allow_mass_assignment_of :width }

  it { should belong_to :user }
  it { should have_one :src_thumb }

  it 'should generate a unique id hash' do
    SrcImage.any_instance.stub(:gen_id_hash).and_return 'some_id_hash'
    src_image = SrcImage.create(:image => test_image)
    expect(src_image.id_hash).to eq('some_id_hash')
  end

  context 'setting fields derived from the image' do

    subject {
      src_image = SrcImage.new(:image => test_image)
      src_image.valid?
      src_image
    }

    its(:content_type) { should == 'image/png' }
    its(:height) { should == 50 }
    its(:width) { should == 460 }
    its(:size) { should == 279 }
  end

end
