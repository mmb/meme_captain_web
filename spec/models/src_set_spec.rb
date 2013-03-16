require 'spec_helper'

describe SrcSet do
  it { should allow_mass_assignment_of :name }
  it { should validate_presence_of :name }

  it { should belong_to :user }
  it { should have_and_belong_to_many :src_images }

  let(:set1) { FactoryGirl.create(:src_set) }

  context "determining the set's thumbnail" do

    it 'uses the most recent image as the thumbnail for the set' do
      si1 = FactoryGirl.create(:src_image, :src_thumb => FactoryGirl.create(:src_thumb))
      si2 = FactoryGirl.create(:src_image, :src_thumb => FactoryGirl.create(:src_thumb))
      si3 = FactoryGirl.create(:src_image, :src_thumb => FactoryGirl.create(:src_thumb))

      set1.src_images << si1
      set1.src_images << si2
      set1.src_images << si3

      expect(set1.thumbnail).to eq si3.src_thumb
    end

    context 'when the set is empty' do

      subject { FactoryGirl.create(:src_set) }

      its(:thumbnail) { should be_nil }
      its(:thumb_width) { should be_nil }
      its(:thumb_height) { should be_nil }

    end

  end

  context 'creating a new src set with the same name as an active src set' do

    it 'fails validation' do
      expect { FactoryGirl.create(:src_set, :name => set1.name) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  context 'creating a new src set with the same name as a deleted src set' do

    it 'allows the src set to be created' do
      set1.is_deleted = true
      set1.save!
      FactoryGirl.create(:src_set, :name => set1.name)
    end

  end

  describe '#size_desc' do

    it "knows what's small" do
      set1.stub_chain(:src_images, :count) { 5 }
      expect(set1.size_desc).to eq :small
    end

    it "knows what's medium" do
      set1.stub_chain(:src_images, :count) { 11 }
      expect(set1.size_desc).to eq :medium
    end

    it "knows what's small" do
      set1.stub_chain(:src_images, :count) { 51 }
      expect(set1.size_desc).to eq :large
    end

  end

end
