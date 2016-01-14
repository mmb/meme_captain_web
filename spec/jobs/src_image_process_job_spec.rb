require 'rails_helper'

describe SrcImageProcessJob do
  subject(:src_image_process_job) { SrcImageProcessJob.new(src_image.id) }
  let(:src_image) { FactoryGirl.create(:src_image) }

  context 'when the image needs to be loaded from a url' do
    let(:url) { 'http://www.example.com/image.jpg' }
    let(:src_image) { FactoryGirl.create(:src_image, image: nil, url: url) }

    before do
      image_data = File.read(Rails.root + 'spec/fixtures/files/ti_duck.jpg')
      stub_request(:get, url).to_return(body: image_data)
      stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0)
    end

    it 'loads the image using the image url composer' do
      src_image_process_job.perform
      src_image.reload
      expect(src_image.magick_image_list.rows).to eq(399)
    end
  end

  context 'when the image is in SVG format' do
    let(:src_image) { FactoryGirl.create(:svg_src_image) }

    it 'converts the image to PNG' do
      expect do
        src_image_process_job.perform
        src_image.reload
      end.to change { src_image.magick_image_list.format }.from('SVG').to('PNG')
    end
  end

  context 'when the src image has orientation exif data' do
    let(:src_image) { FactoryGirl.create(:src_image_with_orientation) }

    it 'auto orients the image' do
      src_image_process_job.perform
      src_image.reload
      magick_image_list = src_image.magick_image_list
      expect(magick_image_list.columns).to eq(50)
      expect(magick_image_list.rows).to eq(600)
    end
  end

  context 'when the src image has a comment' do
    let(:src_image) { FactoryGirl.create(:src_image_with_comment) }

    it 'strips profiles and comments from the image' do
      expect do
        src_image_process_job.perform
        src_image.reload
      end.to change { src_image.magick_image_list[0]['comment'] }.from(
        'the best duck').to(nil)
    end
  end

  context 'when the image is too wide' do
    let(:src_image) do
      FactoryGirl.create(:src_image, image: create_image(100, 50))
    end

    it "reduces the image's width" do
      stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0)
      stub_const('MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE', 80)
      src_image_process_job.perform
      src_image.reload

      expect(src_image.magick_image_list.columns).to eq(80)
      expect(src_image.magick_image_list.rows).to eq(40)
    end
  end

  context 'when the the image is too high' do
    let(:src_image) do
      FactoryGirl.create(:src_image, image: create_image(100, 400))
    end

    it "reduces the image's height" do
      stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0)
      stub_const('MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE', 80)
      src_image_process_job.perform
      src_image.reload

      expect(src_image.magick_image_list.columns).to eq(20)
      expect(src_image.magick_image_list.rows).to eq(80)
    end
  end

  context 'when the image is too small' do
    let(:src_image) do
      FactoryGirl.create(:src_image, image: create_image(20, 50))
    end

    it 'enlarges the image' do
      stub_const('MemeCaptainWeb::Config::ENLARGED_SOURCE_IMAGE_SIDE', 100)
      src_image_process_job.perform
      src_image.reload

      expect(src_image.magick_image_list.columns).to eq 40
      expect(src_image.magick_image_list.rows).to eq 100
    end
  end

  context 'when the image is too big to be processed' do
    let(:src_image) do
      FactoryGirl.create(:src_image, image: create_image(100, 100))
    end

    before do
      stub_const('MemeCaptainWeb::Config::MAX_SRC_IMAGE_SIZE', 1)
    end

    it 'raises SrcImageTooBigError' do
      expect do
        src_image_process_job.perform
      end.to raise_error(
        MemeCaptainWeb::Error::SrcImageTooBigError,
        'image is too large (203 Bytes)')
    end
  end

  context 'watermarking the image' do
    let(:src_image) do
      FactoryGirl.create(:src_image, image: create_image(100, 100))
    end

    before { stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 0) }

    it 'watermarks the image' do
      expect do
        src_image_process_job.perform
        src_image.reload
      end.to change { src_image.magick_image_list.excerpt(54, 95, 46, 5) }
    end
  end

  it 'updates the image' do
    expect do
      src_image_process_job.perform
      src_image.reload
    end.to change { src_image.image }
    expect(src_image.image).to_not be(nil)
  end

  it 'generates a thumbnail' do
    src_image_process_job.perform
    expect(src_image.src_thumb).not_to be_nil
    expect(src_image.src_thumb.width).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
    expect(src_image.src_thumb.height).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
  end

  it 'marks the src image as finished' do
    expect do
      src_image_process_job.perform
      src_image.reload
    end.to change { src_image.work_in_progress }.from(true).to(false)
  end

  it "enqueues a job to set the src image's name" do
    src_image_name_job = instance_double(SrcImageNameJob)
    expect(SrcImageNameJob).to receive(:new).with(src_image.id).and_return(
      src_image_name_job)
    expect(src_image_name_job).to receive(:delay).with(
      queue: :src_image_name).and_return(src_image_name_job)
    expect(src_image_name_job).to receive(:perform)

    src_image_process_job.perform
  end

  it "sets the src image model's content type" do
    expect do
      src_image_process_job.perform
      src_image.reload
    end.to change { src_image.content_type }.from(nil).to('image/jpeg')
  end

  it "sets the src image model's height" do
    expect do
      src_image_process_job.perform
      src_image.reload
    end.to change { src_image.height }.from(nil).to(600)
  end

  it "sets the src image model's size" do
    expect do
      src_image_process_job.perform
      src_image.reload
    end.to change { src_image.size }
  end

  it "sets the src image model's width" do
    expect do
      src_image_process_job.perform
      src_image.reload
    end.to change { src_image.width }.from(nil).to(600)
  end

  describe '#failure' do
    let(:delayed_job) { instance_double(Delayed::Job) }

    context 'when the job last_error is nil' do
      before { allow(delayed_job).to receive(:last_error).and_return(nil) }

      it 'does not update the src image error' do
        expect do
          src_image_process_job.failure(delayed_job)
        end.to_not change { src_image.error }
      end
    end

    context 'when the job last_error is empty' do
      before { allow(delayed_job).to receive(:last_error).and_return('') }

      it 'does not update the src image error' do
        expect do
          src_image_process_job.failure(delayed_job)
        end.to_not change { src_image.error }
      end
    end

    context 'when the job last_error is not blank' do
      before do
        allow(delayed_job).to receive(:last_error).and_return(
          "an error\na traceback")
      end

      it 'updates the error field to the first line of the error' do
        src_image_process_job.failure(delayed_job)
        src_image.reload
        expect(src_image.error).to eq('an error')
      end
    end

    context 'when the job last_error has only one line' do
      before do
        allow(delayed_job).to receive(:last_error).and_return(
          'another error')
      end

      it 'updates the error field to the first line of the error' do
        src_image_process_job.failure(delayed_job)
        src_image.reload
        expect(src_image.error).to eq('another error')
      end
    end
  end

  describe '#reschedule_at' do
    it 'reschedules in 1 second' do
      expect(src_image_process_job.reschedule_at(123, 0)).to eq(124)
    end
  end

  describe '#max_attempts' do
    it 'is 3' do
      expect(src_image_process_job.max_attempts).to eq(3)
    end
  end
end
