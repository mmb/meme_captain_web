require 'rails_helper'

describe SrcImageProcessJob, type: :job do
  context 'when the image needs to be loaded from a url' do
    it 'loads the image using the image url composer' do
      url = 'http://www.example.com/image.jpg'
      image_data = File.read(Rails.root + 'spec/fixtures/files/ti_duck.jpg')
      stub_request(:get, url).to_return(body: image_data)

      stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0)

      src_image = FactoryGirl.create(:src_image, image: nil, url: url)
      SrcImageProcessJob.perform_now(src_image)
      expect(src_image.magick_image_list.rows).to eq(399)
    end
  end

  it 'auto orients the image'

  it 'strips profiles and comments from the image'

  context 'when the image is too wide' do
    it "reduces the image's width" do
      stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0)
      stub_const('MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE', 80)
      src_image = FactoryGirl.create(
        :src_image, image: create_image(100, 50))
      SrcImageProcessJob.perform_now(src_image)

      expect(src_image.magick_image_list.columns).to eq(80)
      expect(src_image.magick_image_list.rows).to eq(40)
    end
  end

  context 'when the the image is too high' do
    it "reduces the image's height" do
      stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0)
      stub_const('MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE', 80)
      src_image = FactoryGirl.create(
        :src_image, image: create_image(100, 400))
      SrcImageProcessJob.perform_now(src_image)

      expect(src_image.magick_image_list.columns).to eq(20)
      expect(src_image.magick_image_list.rows).to eq(80)
    end
  end

  context 'when the image is too small' do
    it 'enlarges the image' do
      stub_const('MemeCaptainWeb::Config::ENLARGED_SOURCE_IMAGE_SIDE', 100)
      src_image = FactoryGirl.create(:src_image, image: create_image(20, 50))
      SrcImageProcessJob.perform_now(src_image)

      expect(src_image.magick_image_list.columns).to eq 40
      expect(src_image.magick_image_list.rows).to eq 100
    end
  end

  it 'watermarks the image' do
    stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0)
    src_image = FactoryGirl.create(:src_image, image: create_image(100, 100))

    expect do
      SrcImageProcessJob.perform_now(src_image)
    end.to change { src_image.magick_image_list.excerpt(54, 95, 46, 5) }
  end

  it 'updates the image' do
    src_image = FactoryGirl.create(:src_image)
    expect do
      SrcImageProcessJob.perform_now(src_image)
    end.to change { src_image.image }
    expect(src_image.image).to_not be(nil)
  end

  it 'generates a thumbnail' do
    src_image = FactoryGirl.create(:src_image)
    SrcImageProcessJob.perform_now(src_image)
    expect(src_image.src_thumb).not_to be_nil
    expect(src_image.src_thumb.width).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
    expect(src_image.src_thumb.height).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
  end

  it 'marks the src image as finished' do
    src_image = FactoryGirl.create(:src_image)
    expect do
      SrcImageProcessJob.perform_now(src_image)
    end.to change { src_image.work_in_progress }.from(true).to(false)
  end

  it "enqueues a job to set the src image's name" do
    src_image = FactoryGirl.create(:src_image)
    expect(SrcImageNameJob).to receive(:perform_later).with(src_image)
    SrcImageProcessJob.perform_now(src_image)
  end

  context 'when the source image fails to save' do
    it 'raises a record invalid exception' do
      src_image = FactoryGirl.create(:src_image)
      expect(src_image).to receive(:valid?).and_return(false)
      expect do
        SrcImageProcessJob.perform_now(src_image)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
