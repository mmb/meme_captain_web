require 'spec_helper'

describe GendImage do

  it { should_not allow_mass_assignment_of :id_hash }
  it { should validate_uniqueness_of :id_hash }

  it { should allow_mass_assignment_of :image }

  it { should allow_mass_assignment_of :src_image_id }

  it { should belong_to :src_image }

  it { should have_one :gend_thumb }

  it { should have_many :captions }

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

    its(:content_type) { should == 'image/jpeg' }
    its(:height) { should == 399 }
    its(:width) { should == 399 }
    its(:size) { should == 9141 }
  end

  it 'generates a thumbnail'
  # figure out how to use run a delayed job in spec

end
