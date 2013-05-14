require 'spec_helper'

describe GendImage do

  it { should_not allow_mass_assignment_of :id_hash }
  it { should validate_uniqueness_of :id_hash }

  it { should allow_mass_assignment_of :image }

  it { should allow_mass_assignment_of :src_image_id }

  it { should allow_mass_assignment_of :captions_attributes }

  it { should allow_mass_assignment_of :private }

  it { should belong_to :src_image }

  it { should belong_to :user }

  it { should have_one :gend_thumb }

  it { should have_many :captions }

  it { should_not validate_presence_of :user }

  it 'should generate a unique id hash' do
    gend_image = FactoryGirl.create(:gend_image)
    expect(gend_image.id_hash).to_not be_nil
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
