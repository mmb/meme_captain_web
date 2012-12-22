require 'spec_helper'

describe SrcImage do

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
  it { should have_many :gend_images }

  it 'should generate a unique id hash' do
    SrcImage.any_instance.stub(:gen_id_hash).and_return 'some_id_hash'
    src_image = SrcImage.create(FactoryGirl.attributes_for(:src_image))
    expect(src_image.id_hash).to eq('some_id_hash')
  end

  context 'setting fields derived from the image' do

    subject {
      src_image = SrcImage.new(FactoryGirl.attributes_for(:src_image))
      src_image.valid?
      src_image
    }

    its(:content_type) { should == 'image/png' }
    its(:height) { should == 50 }
    its(:width) { should == 460 }
    its(:size) { should == 279 }
  end

  it 'should not delete child gend_images when deleted'

  it 'generates a thumbnail'
  # figure out how to use run a delayed job in spec

end
