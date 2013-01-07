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
  it { should have_and_belong_to_many :src_sets }

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

    its(:content_type) { should == 'image/jpeg' }
    its(:height) { should == 399 }
    its(:width) { should == 399 }
    its(:size) { should == 9141 }
  end

  it 'should not delete child gend_images when deleted'

  it 'generates a thumbnail'
  # figure out how to use run a delayed job in spec

  context 'generating a Magick::Image from its data' do

    subject {
      SrcImage.new(FactoryGirl.attributes_for(:src_image))
    }

    its(:'magick_image_list.columns') { should == 399 }
    its(:'magick_image_list.rows') { should == 399 }

  end

end
