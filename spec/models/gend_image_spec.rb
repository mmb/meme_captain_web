require 'base64'

require 'spec_helper'

describe GendImage do

  let(:test_image) {
    Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAcwAAAAyAgMAAACsWgPIAAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wBHwQoJY1iyrwAAAAJUExURQAAAAAAAP///4Pdz9IAAAABdFJOUwBA5thmAAAAAWJLR0QB/wIt3gAAAHpJREFUWIXt1zESgCAMRNE03s9mG+9ns6e0EaKCqDOWf4sUJOHREvqciOn7Us0cEZiYmJhnc7HtVbJtS5LsVRo09DScZzmSG5iYmJit2RTVlduGquS920hFvxRMTEzMRzOv6TfKheMX9ThMTEzMnvlj5ld/S0xMTMxjNoGjc3pdi6L4AAAAAElFTkSuQmCC')
  }

  it { should_not allow_mass_assignment_of :id_hash }
  it { should validate_uniqueness_of :id_hash }

  it { should validate_presence_of :image }
  it { should allow_mass_assignment_of :image }

  it { should allow_mass_assignment_of :src_image_id }

  it { should belong_to :src_image }

  it { pending; should have_many :caption_text }

  it 'should generate a unique id hash' do
    GendImage.any_instance.stub(:gen_id_hash).and_return 'some_id_hash'
    gend_image = GendImage.create(:image => test_image)
    expect(gend_image.id_hash).to eq('some_id_hash')
  end

  context 'setting fields derived from the image' do

    subject {
      gend_image = GendImage.new(:image => test_image)
      gend_image.valid?
      gend_image
    }

    its(:content_type) { should == 'image/png' }
    its(:height) { should == 50 }
    its(:width) { should == 460 }
    its(:size) { should == 279 }
  end

end
