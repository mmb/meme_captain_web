# encoding: UTF-8

require 'rails_helper'

require 'support/src_image_skip_callbacks'

describe SrcSet do
  it { should validate_presence_of :name }

  it { should belong_to :user }
  it { should have_and_belong_to_many :src_images }

  let(:set1) { FactoryGirl.create(:src_set) }

  context "determining the set's thumbnail" do
    it 'uses the most used image as the thumbnail for the set' do
      si1 = FactoryGirl.create(:finished_src_image, gend_images_count: 3)
      si2 = FactoryGirl.create(:finished_src_image, gend_images_count: 2)
      si3 = FactoryGirl.create(:finished_src_image, gend_images_count: 1)

      set1.src_images << si1
      set1.src_images << si2
      set1.src_images << si3

      expect(set1.thumbnail_image).to eq(si1)
    end

    context 'when the set is empty' do
      subject(:src_set) { FactoryGirl.create(:src_set) }

      specify { expect(src_set.thumbnail_image).to be_nil }
    end

    context 'when all images in the set are deleted' do
      it 'returns nil' do
        src_set = FactoryGirl.create(:src_set)
        src_set.src_images << FactoryGirl.create(:src_image, is_deleted: true)
        src_set.src_images << FactoryGirl.create(:src_image, is_deleted: true)

        expect(src_set.thumbnail_image).to be_nil
      end
    end

    context 'when some images in the set are in progress' do
      it 'ignores the in progress images' do
        src_set = FactoryGirl.create(:src_set)
        src_set.src_images << FactoryGirl.create(
          :src_image, work_in_progress: true
        )
        si = FactoryGirl.create(:finished_src_image)
        src_set.src_images << si

        expect(src_set.thumbnail_image).to eq(si)
      end
    end
  end

  context 'creating a new src set with the same name as an active src set' do
    it 'fails validation' do
      expect { FactoryGirl.create(:src_set, name: set1.name) }.to(
        raise_error(ActiveRecord::RecordInvalid)
      )
    end
  end

  context 'creating a new src set with the same name as a deleted src set' do
    it 'allows the src set to be created' do
      set1.is_deleted = true
      set1.save!
      FactoryGirl.create(:src_set, name: set1.name)
    end
  end

  describe '.name_matches' do
    it 'matches at the beginning' do
      src_set1 = FactoryGirl.create(:src_set, name: 'test')
      FactoryGirl.create(:src_set, name: 'no match')
      expect(SrcSet.name_matches('test')).to eq([src_set1])
    end

    it 'matches in the middle' do
      src_set1 = FactoryGirl.create(:src_set, name: 'this is a test!')
      FactoryGirl.create(:src_set, name: 'no match')
      expect(SrcSet.name_matches('test')).to eq([src_set1])
    end

    it 'matches at the end' do
      src_set1 = FactoryGirl.create(:src_set, name: 'this is a test')
      FactoryGirl.create(:src_set, name: 'no match')
      expect(SrcSet.name_matches('test')).to eq([src_set1])
    end

    it 'matches case insensitive' do
      src_set1 = FactoryGirl.create(:src_set, name: 'TeSt')
      FactoryGirl.create(:src_set, name: 'no match')
      expect(SrcSet.name_matches('test')).to eq([src_set1])
    end
  end

  describe 'setting the search document' do
    it 'sets the search document' do
      src_set1 = FactoryGirl.create(:src_set, name: 'test')
      expect(src_set1.search_document).to eq('test')
    end
  end

  describe '#add_src_images' do
    it 'adds src images to the set' do
      src_image1 = FactoryGirl.create(:src_image)
      src_image2 = FactoryGirl.create(:src_image)
      src_image3 = FactoryGirl.create(:src_image)

      set1.add_src_images([
                            src_image1.id_hash,
                            src_image2.id_hash,
                            src_image3.id_hash
                          ])

      set1.add_src_images([
                            src_image2.id_hash
                          ])

      set1.save!

      expect(set1.src_images.size).to eq(3)
      expect(set1.src_images_count).to eq(3)
    end
  end

  describe '#delete_src_images' do
    it 'deletes src images from the set' do
      src_image1 = FactoryGirl.create(:src_image)
      src_image2 = FactoryGirl.create(:src_image)
      src_image3 = FactoryGirl.create(:src_image)

      set1.add_src_images([
                            src_image1.id_hash,
                            src_image2.id_hash,
                            src_image3.id_hash
                          ])

      set1.delete_src_images([
                               src_image2.id_hash,
                               src_image3.id_hash
                             ])

      set1.delete_src_images([
                               src_image2.id_hash
                             ])

      set1.save!

      expect(set1.src_images.size).to eq(1)
      expect(set1.src_images_count).to eq(1)
    end
  end

  describe '#update_src_images_count' do
    it 'sets the src_images_count to the number of active src images' do
      src_image1 = FactoryGirl.create(:src_image)
      src_image2 = FactoryGirl.create(:src_image, is_deleted: true)
      src_image3 = FactoryGirl.create(:src_image)

      set1.add_src_images([
                            src_image1.id_hash,
                            src_image2.id_hash,
                            src_image3.id_hash
                          ])

      set1.update_src_images_count
      expect(set1.src_images_count).to eq(2)
    end
  end

  describe '.not_empty' do
    context 'when the src set contains images' do
      before do
        src_image1 = FactoryGirl.create(:src_image)
        src_image2 = FactoryGirl.create(:src_image, is_deleted: true)
        src_image3 = FactoryGirl.create(:src_image)

        set1.add_src_images([
                              src_image1.id_hash,
                              src_image2.id_hash,
                              src_image3.id_hash
                            ])
        set1.save!
      end

      it 'finds the set' do
        expect(SrcSet.not_empty).to include(set1)
      end
    end

    context 'when the src set does not contain images' do
      before do
        set1
      end

      it 'does not find the set' do
        expect(SrcSet.not_empty).to be_empty
      end
    end
  end
end
