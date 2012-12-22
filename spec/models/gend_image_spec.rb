require 'spec_helper'

describe GendImage do

  it { should_not allow_mass_assignment_of :id_hash }
  it { should validate_uniqueness_of :id_hash }

  it { should validate_presence_of :image }
  it { should allow_mass_assignment_of :image }

  it { should allow_mass_assignment_of :src_image_id }

  it { should belong_to :src_image }

  it { should have_one :gend_thumb }

  it { pending; should have_many :caption_text }

  it 'should generate a unique id hash' do
    GendImage.any_instance.stub(:gen_id_hash).and_return 'some_id_hash'
    gend_image = GendImage.create(FactoryGirl.attributes_for(:gend_image))
    expect(gend_image.id_hash).to eq('some_id_hash')
  end

  context 'setting fields derived from the image' do

    subject {
      gend_image = GendThumb.new(FactoryGirl.attributes_for(:gend_image))
      gend_image.valid?
      gend_image
    }

    its(:content_type) { should == 'image/png' }
    its(:height) { should == 50 }
    its(:width) { should == 460 }
    its(:size) { should == 279 }
  end

  it 'generates a thumbnail'
  # figure out how to use run a delayed job in spec

end
