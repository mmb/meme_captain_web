# encoding: UTF-8

require 'rails_helper'

describe SrcImage do
  it { should_not validate_presence_of :content_type }

  it { should_not validate_presence_of :height }

  it { should validate_uniqueness_of :id_hash }

  it { should_not validate_presence_of :image }

  it { should_not validate_presence_of :name }

  it { should_not validate_presence_of :size }

  it { should_not validate_presence_of :url }

  it { should_not validate_presence_of :width }

  it { should belong_to :user }
  it { should have_one :src_thumb }
  it { should have_many :gend_images }
  it { should have_and_belong_to_many :src_sets }

  it 'should generate a unique id hash' do
    allow(SecureRandom).to receive(:urlsafe_base64).with(4).and_return(
      'some_id_hash')
    src_image = SrcImage.create(FactoryGirl.attributes_for(:src_image))
    expect(src_image.id_hash).to eq('some_id_hash')
  end

  context 'setting fields derived from the image' do
    context 'when the image is not animated' do
      subject(:src_image) do
        src_image = SrcImage.new(FactoryGirl.attributes_for(:src_image))
        src_image.set_derived_image_fields
        src_image.valid?
        src_image
      end

      specify { expect(src_image.content_type).to eq('image/jpeg') }
      specify { expect(src_image.height).to eq(399) }
      specify { expect(src_image.width).to eq(399) }
      specify { expect(src_image.size).to eq(9141) }
      specify { expect(src_image.is_animated).to eq(false) }
    end

    context 'when the image is animated' do
      subject(:src_image) do
        src_image = SrcImage.new(
          FactoryGirl.attributes_for(:animated_src_image))
        src_image.set_derived_image_fields
        src_image.valid?
        src_image
      end

      specify { expect(src_image.is_animated).to eq(true) }
    end
  end

  it 'should not delete child gend_images when deleted' do
    src_image = FactoryGirl.create(:src_image)
    FactoryGirl.create(:gend_image, src_image: src_image)
    FactoryGirl.create(:gend_image, src_image: src_image)
    expect { src_image.destroy }.not_to change { GendImage.count }
  end

  context 'generating a Magick::Image from its data' do
    subject(:src_image) do
      SrcImage.new(FactoryGirl.attributes_for(:src_image))
    end

    specify { expect(src_image.magick_image_list.columns).to eq(399) }
    specify { expect(src_image.magick_image_list.rows).to eq(399) }
  end

  describe 'adding the URL scheme' do
    let(:src_image) { FactoryGirl.create(:src_image, url: url) }

    context 'when the URL is nil' do
      let(:url) { nil }

      it 'does not add a scheme' do
        expect(src_image.url).to be(nil)
      end
    end

    context 'when the URL is empty' do
      let(:url) { '' }

      it 'does not add a scheme' do
        expect(src_image.url).to eq('')
      end
    end

    context 'when the URL has a scheme of http' do
      let(:url) { 'http://images.com/image.png' }

      it 'does not add a scheme' do
        expect(src_image.url).to eq(url)
      end
    end

    context 'when the URL has a scheme of https' do
      let(:url) { 'https://images.com/image.png' }

      it 'does not add a scheme' do
        expect(src_image.url).to eq(url)
      end
    end

    context 'when the URL is a data URI' do
      let(:url) do
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAA' \
        'AAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=='
      end

      it 'does not add a scheme' do
        expect(src_image.url).to eq(url)
      end
    end

    context 'when the URL does not have a scheme' do
      let(:url) { 'images.com/image.png' }

      it 'defaults the scheme to http' do
        expect(src_image.url).to eq('http://images.com/image.png')
      end
    end
  end

  describe '#image_if_not_url' do
    let(:attrs) { { image: nil, url: nil } }

    subject { FactoryGirl.build(:src_image, attrs) }

    context 'when image and url are blank' do
      it { should_not be_valid }
    end

    context 'when image is set and url is blank' do
      let(:attrs) { { url: nil } }
      it { should be_valid }
    end

    context 'when image is blank and url is set' do
      let(:attrs) { { image: nil, url: 'abc' } }
      it { should be_valid }
    end

    context 'when both are set' do
      let(:attrs) { { url: 'abc' } }
      it { should be_valid }
    end
  end

  describe '#load_from_url' do
    context 'when url is nil' do
      it 'does not load the image' do
        src_image = FactoryGirl.create(:src_image, url: nil)
        expect do
          src_image.load_from_url
        end.not_to change { src_image.image }
      end
    end

    context 'when url is not nil' do
      before do
        stub_request(:get, 'http://example.com/image.jpg').to_return(
          body: create_image(37, 22))
      end

      it 'loads the image' do
        src_image = FactoryGirl.create(
          :src_image, url: 'http://example.com/image.jpg')
        src_image.load_from_url
        expect(src_image.magick_image_list.columns).to eq(37)
        expect(src_image.magick_image_list.rows).to eq(22)
      end
    end
  end

  describe '#create_jobs' do
    context 'when the url is nil' do
      let(:src_image) { FactoryGirl.create(:src_image, url: nil) }

      it 'enqueues a src image processing job in the src_image_process queue' do
        src_image_process_job = instance_double(SrcImageProcessJob)
        expect(SrcImageProcessJob).to receive(:new).with(
          src_image.id).and_return(src_image_process_job)
        expect(src_image_process_job).to receive(:delay).with(
          queue: :src_image_process).and_return(src_image_process_job)
        expect(src_image_process_job).to receive(:perform)

        src_image.run_callbacks(:commit)
      end
    end

    context 'when the url is not nil' do
      let(:src_image) { FactoryGirl.create(:src_image, url: 'some url') }

      it 'enqueues a src image processing job in the src_image_process_url ' \
        'queue' do
        src_image_process_job = instance_double(SrcImageProcessJob)
        expect(SrcImageProcessJob).to receive(:new).with(
          src_image.id).and_return(src_image_process_job)
        expect(src_image_process_job).to receive(:delay).with(
          queue: :src_image_process_url).and_return(src_image_process_job)
        expect(src_image_process_job).to receive(:perform)

        src_image.run_callbacks(:commit)
      end
    end
  end

  describe '#format' do
    it 'returns the file extension' do
      src_image = FactoryGirl.create(:src_image)
      src_image.set_derived_image_fields
      expect(src_image.format).to eq(:jpg)
    end
  end

  describe '#as_json' do
    it 'returns the JSON representation of the model' do
      src_image = FactoryGirl.create(:src_image, name: 'test image')
      src_image.set_derived_image_fields
      src_image.save!
      src_image.image_url = 'test image url'
      expect(src_image.as_json).to eq(
        'id_hash' => src_image.id_hash,
        'width' => 399,
        'height' => 399,
        'size' => 9141,
        'content_type' => 'image/jpeg',
        'created_at' => src_image.created_at,
        'updated_at' => src_image.updated_at,
        'name' => 'test image',
        'image_url' => 'test image url')
    end
  end

  describe '.without_image' do
    it 'does not load the image data' do
      FactoryGirl.create(:finished_src_image)
      expect do
        SrcImage.without_image.first.image
      end.to raise_error(ActiveModel::MissingAttributeError)
    end
  end

  describe '.name_matches' do
    it 'finds images where the query is a subtring of their name' do
      si1 = FactoryGirl.create(:src_image, name: 'the quick brown fox')
      FactoryGirl.create(:src_image, name: 'not a match')
      si3 = FactoryGirl.create(:src_image, name: 'fox brown quick then')
      expect(SrcImage.name_matches('quick')).to contain_exactly(si1, si3)
    end

    it 'it case insensitive' do
      si1 = FactoryGirl.create(:src_image, name: 'the quick brown fox')
      expect(SrcImage.name_matches('QuIcK')).to contain_exactly(si1)
    end

    it 'strips whitespace' do
      si1 = FactoryGirl.create(:src_image, name: 'the quick brown fox')
      expect(SrcImage.name_matches(" quick\t\r\n")).to contain_exactly(si1)
    end
  end

  describe '.publick' do
    it 'finds images that are not private' do
      si1 = FactoryGirl.create(:src_image, private: false)
      FactoryGirl.create(:src_image, private: true)
      si3 = FactoryGirl.create(:src_image, private: false)
      expect(SrcImage.publick).to contain_exactly(si1, si3)
    end
  end

  describe '.active' do
    it 'finds images that are not deleted' do
      FactoryGirl.create(:src_image, is_deleted: true)
      si2 = FactoryGirl.create(:src_image, is_deleted: false)
      FactoryGirl.create(:src_image, is_deleted: true)
      expect(SrcImage.active).to contain_exactly(si2)
    end
  end

  describe '.finished' do
    it 'finds images that are not in progress' do
      FactoryGirl.create(:src_image, work_in_progress: true)
      si2 = FactoryGirl.create(:src_image, work_in_progress: false)
      si3 = FactoryGirl.create(:src_image, work_in_progress: false)
      expect(SrcImage.finished).to contain_exactly(si2, si3)
    end
  end

  describe '.most_used' do
    it 'order the images by most used' do
      si1 = FactoryGirl.create(:src_image, gend_images_count: 20)
      si2 = FactoryGirl.create(:src_image, gend_images_count: 10)
      si3 = FactoryGirl.create(:src_image, gend_images_count: 30)
      expect(SrcImage.most_used(3)).to eq([si3, si1, si2])
    end
  end

  describe '.for_user' do
    let(:relation) { double(ActiveRecord::Relation) }
    let(:result) { double(ActiveRecord::Relation) }

    context 'when the user is nil' do
      let(:user) { nil }

      it 'returns images that are not private, deleted or in progress' do
        expect(SrcImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:includes).with(:src_thumb).and_return(
          relation)
        expect(relation).to receive(:name_matches).with('query').and_return(
          relation)
        expect(relation).to receive(:publick).and_return(relation)
        expect(relation).to receive(:active).and_return(relation)
        expect(relation).to receive(:finished).and_return(relation)
        expect(relation).to receive(:most_used).and_return(relation)
        expect(relation).to receive(:page).with(1).and_return(result)
        expect(SrcImage.for_user(user, 'query', 1)).to eq(result)
      end
    end

    context 'when the user is not an admin user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns images that are not private, deleted or in progress' do
        expect(SrcImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:includes).with(:src_thumb).and_return(
          relation)
        expect(relation).to receive(:name_matches).with('query').and_return(
          relation)
        expect(relation).to receive(:publick).and_return(relation)
        expect(relation).to receive(:active).and_return(relation)
        expect(relation).to receive(:finished).and_return(relation)
        expect(relation).to receive(:most_used).and_return(relation)
        expect(relation).to receive(:page).with(1).and_return(result)
        expect(SrcImage.for_user(user, 'query', 1)).to eq(result)
      end
    end

    context 'when the user is an admin user' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'returns all images' do
        expect(SrcImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:includes).with(:src_thumb).and_return(
          relation)
        expect(relation).to receive(:name_matches).with('query').and_return(
          relation)
        expect(relation).to receive(:most_used).and_return(relation)
        expect(relation).to receive(:page).with(1).and_return(result)
        expect(SrcImage.for_user(user, 'query', 1)).to eq(result)
      end
    end
  end
end
