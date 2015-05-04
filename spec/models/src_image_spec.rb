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

    subject(:src_image) do
      src_image = SrcImage.new(FactoryGirl.attributes_for(:src_image))
      src_image.valid?
      src_image
    end

    specify { expect(src_image.content_type).to eq('image/jpeg') }
    specify { expect(src_image.height).to eq(399) }
    specify { expect(src_image.width).to eq(399) }
    specify { expect(src_image.size).to eq(9141) }
  end

  it 'should not delete child gend_images when deleted' do
    src_image = FactoryGirl.create(:src_image)
    FactoryGirl.create(:gend_image, src_image: src_image)
    FactoryGirl.create(:gend_image, src_image: src_image)
    expect { src_image.destroy }.not_to change { GendImage.count }
  end

  it 'generates a thumbnail' do
    src_image = FactoryGirl.create(:src_image)
    src_image.post_process_job
    expect(src_image.src_thumb).not_to be_nil
    expect(src_image.src_thumb.width).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
    expect(src_image.src_thumb.height).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
  end

  context 'generating a Magick::Image from its data' do

    subject(:src_image) do
      SrcImage.new(FactoryGirl.attributes_for(:src_image))
    end

    specify { expect(src_image.magick_image_list.columns).to eq(399) }
    specify { expect(src_image.magick_image_list.rows).to eq(399) }
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
    let(:url) { 'http://www.example.com/image.jpg' }
    let(:image_data) do
      File.read(Rails.root + 'spec/fixtures/files/ti_duck.jpg')
    end

    before do
      stub_const 'MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0
    end

    it 'loads the image from a url' do
      stub_request(:get, url).to_return(body: image_data)
      src_image = FactoryGirl.create(:src_image, image: nil, url: url)
      src_image.post_process_job
      expect(src_image.magick_image_list.rows).to eq 399
    end

    context 'vertical join' do

      it 'joins the image vertically' do
        stub_request(:get, 'http://example.com/image.jpg').to_return(
          body: create_image(100, 50))
        stub_request(:get, 'http://example.com/image2.jpg').to_return(
          body: create_image(105, 50))
        stub_request(:get, 'http://example.com/image3.jpg').to_return(
          body: create_image(110, 50))
        src_image = FactoryGirl.create(:src_image,
                                       image: nil,
                                       url: 'http://example.com/image.jpg|' \
                                           'http://example.com/image2.jpg|' \
                                           'http://example.com/image3.jpg')
        src_image.post_process_job

        expect(src_image.magick_image_list.columns).to eq 100
        expect(src_image.magick_image_list.rows).to eq 143
      end

    end

    context 'horizontal join' do

      it 'joins the image horizontally' do
        stub_request(:get, 'http://example.com/image.jpg').to_return(
          body: create_image(100, 50))
        stub_request(:get, 'http://example.com/image2.jpg').to_return(
          body: create_image(100, 75))
        stub_request(:get, 'http://example.com/image3.jpg').to_return(
          body: create_image(100, 100))
        src_image = FactoryGirl.create(:src_image,
                                       image: nil,
                                       url: 'http://example.com/image.jpg[]' \
                                           'http://example.com/image2.jpg[]' \
                                           'http://example.com/image3.jpg')
        src_image.post_process_job

        expect(src_image.magick_image_list.columns).to eq 217
        expect(src_image.magick_image_list.rows).to eq 50
      end
    end

    context 'mixed join' do

      it 'joins the image vertically and then horizontally' do
        stub_request(:get, 'http://example.com/image.jpg').to_return(
          body: create_image(100, 100))
        stub_request(:get, 'http://example.com/image2.jpg').to_return(
          body: create_image(100, 100))
        stub_request(:get, 'http://example.com/image3.jpg').to_return(
          body: create_image(100, 100))
        src_image = FactoryGirl.create(:src_image,
                                       image: nil,
                                       url: 'http://example.com/image.jpg|' \
                                           'http://example.com/image2.jpg[]' \
                                           'http://example.com/image3.jpg')
        src_image.post_process_job

        expect(src_image.magick_image_list.columns).to eq 100
        expect(src_image.magick_image_list.rows).to eq 150
      end
    end

  end

  context 'constraining the image to a maximum size' do

    before do
      stub_const 'MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0
      stub_const 'MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE', 80
    end

    context 'when the the image is too wide' do
      it "reduces the image's width" do
        src_image = FactoryGirl.create(
          :src_image, image: create_image(100, 50))
        src_image.post_process_job

        expect(src_image.magick_image_list.columns).to eq 80
        expect(src_image.magick_image_list.rows).to eq 40
      end
    end

    context 'when the the image is too high' do
      it "reduces the image's height" do
        src_image = FactoryGirl.create(
          :src_image, image: create_image(100, 400))
        src_image.post_process_job

        expect(src_image.magick_image_list.columns).to eq 20
        expect(src_image.magick_image_list.rows).to eq 80
      end
    end
  end

  context 'when the image is too small' do

    before do
      stub_const 'MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 60
      stub_const 'MemeCaptainWeb::Config::ENLARGED_SOURCE_IMAGE_SIDE', 100
    end

    it 'enlarges the image' do
      src_image = FactoryGirl.create(:src_image, image: create_image(20, 50))
      src_image.post_process_job

      expect(src_image.magick_image_list.columns).to eq 40
      expect(src_image.magick_image_list.rows).to eq 100
    end

  end

  context 'adding a watermark' do
    before { stub_const 'MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0 }

    it 'watermarks the image' do
      src_image = FactoryGirl.create(:src_image, image: create_image(100, 100))

      expect do
        src_image.post_process_job
      end.to change { src_image.magick_image_list.excerpt(54, 95, 46, 5) }
    end
  end

end
