require 'rails_helper'

describe GendImageProcessJob, type: :job do
  include ActiveJob::TestHelper

  it 'generates the meme image' do
    gend_image = FactoryGirl.create(:gend_image, image: nil)
    GendImageProcessJob.perform_now(gend_image)
    expect(gend_image.magick_image_list.columns).to eq(399)
    expect(gend_image.magick_image_list.rows).to eq(399)
  end

  it 'generates a thumbnail' do
    gend_image = FactoryGirl.create(:gend_image)
    GendImageProcessJob.perform_now(gend_image)
    expect(gend_image.gend_thumb).not_to be_nil
    expect(gend_image.gend_thumb.width).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
    expect(gend_image.gend_thumb.height).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
  end

  it 'marks the gend image as finished' do
    gend_image = FactoryGirl.create(:gend_image)
    expect do
      GendImageProcessJob.perform_now(gend_image)
    end.to change { gend_image.work_in_progress }.from(true).to(false)
  end

  context 'when the src image is not animated' do
    let(:gend_image) do
      src_image = SrcImage.new(FactoryGirl.attributes_for(:src_image))
      src_image.set_derived_image_fields
      src_image.valid?
      FactoryGirl.create(:gend_image, src_image: src_image)
    end

    it 'creates the job in the gend_image_process_animated queue' do
      GendImageProcessJob.perform_later(gend_image)
      expect(enqueued_jobs.first[:queue]).to eq('gend_image_process')
    end
  end

  context 'when the src image is animated' do
    let(:gend_image) do
      src_image = SrcImage.new(FactoryGirl.attributes_for(:animated_src_image))
      src_image.set_derived_image_fields
      src_image.valid?
      FactoryGirl.create(:animated_gend_image, src_image: src_image)
    end

    it 'creates the job in the gend_image_process_animated queue' do
      GendImageProcessJob.perform_later(gend_image)
      expect(enqueued_jobs.first[:queue]).to eq('gend_image_process_animated')
    end
  end
end
