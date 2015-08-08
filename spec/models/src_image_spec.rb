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
    it 'enqueues a src image processing job' do
      src_image = FactoryGirl.create(:src_image)
      expect(SrcImageProcessJob).to receive(:perform_later).with(src_image.id)
      src_image.run_callbacks(:commit)
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
end
