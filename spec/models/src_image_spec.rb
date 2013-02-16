require 'spec_helper'

describe SrcImage do

  it { should_not validate_presence_of :content_type }
  it { should_not allow_mass_assignment_of :content_type }

  it { should_not validate_presence_of :height }
  it { should_not allow_mass_assignment_of :height }

  it { should_not allow_mass_assignment_of :id_hash }
  it { should validate_uniqueness_of :id_hash }

  it { should_not validate_presence_of :image }
  it { should allow_mass_assignment_of :image }

  it { should_not validate_presence_of :size }
  it { should_not allow_mass_assignment_of :size }

  it { should_not validate_presence_of :url }
  it { should allow_mass_assignment_of :url }

  it { should_not validate_presence_of :width }
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

  describe '#image_if_not_url' do

    let(:attrs) { {:image => nil, :url => nil} }

    subject { FactoryGirl.build(:src_image, attrs) }

    context 'when image and url are blank' do
      it { should_not be_valid }
    end

    context 'when image is set and url is blank' do
      let(:attrs) { {:url => nil} }
      it { should be_valid }
    end

    context 'when image is blank and url is set' do
      let(:attrs) { {:image => nil, :url => 'abc'} }
      it { should be_valid }
    end

    context 'when both are set' do
      let(:attrs) { {:url => 'abc'} }
      it { should be_valid }
    end

  end

  describe "#load_from_url" do
    let(:url) { 'http://www.example.com/image.jpg' }
    let(:image_data) { File.read(Rails.root + 'spec/fixtures/files/ti_duck.jpg') }

    it 'loads the image from a url' do
      stub_request(:get, url).to_return(:body => image_data)
      src_image = FactoryGirl.create(:src_image, :image => nil, :url => url)
      src_image.post_process_job
      expect(src_image.magick_image_list.rows).to eq 399
    end

  end

end
