require 'rails_helper'

describe GendImageProcessJob, type: :job do
  include ActiveJob::TestHelper

  it 'generates the meme image' do
    gend_image = FactoryGirl.create(:gend_image, image: nil)
    GendImageProcessJob.perform_now(gend_image.id)
    gend_image.reload
    expect(gend_image.magick_image_list.columns).to eq(399)
    expect(gend_image.magick_image_list.rows).to eq(399)
  end

  it 'generates a thumbnail' do
    gend_image = FactoryGirl.create(:gend_image)
    GendImageProcessJob.perform_now(gend_image.id)
    expect(gend_image.gend_thumb).not_to be_nil
    expect(gend_image.gend_thumb.width).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
    expect(gend_image.gend_thumb.height).to eq(
      MemeCaptainWeb::Config::THUMB_SIDE)
  end

  it 'marks the gend image as finished' do
    gend_image = FactoryGirl.create(:gend_image)
    expect do
      GendImageProcessJob.perform_now(gend_image.id)
      gend_image.reload
    end.to change { gend_image.work_in_progress }.from(true).to(false)
  end

  context 'when the src image is not animated' do
    let(:gend_image) do
      src_image = SrcImage.new(FactoryGirl.attributes_for(:src_image))
      src_image.set_derived_image_fields
      src_image.valid?
      FactoryGirl.create(:gend_image, src_image: src_image)
    end
  end

  context 'when the image is small' do
    it 'puts the image in the small queue' do
      gend_image = FactoryGirl.create(:gend_image)
      gend_image.src_image.size = 51_200
      gend_image.src_image.save!
      GendImageProcessJob.perform_later(gend_image.id)
      expect(enqueued_jobs.first[:queue]).to eq('gend_image_process_small')
    end
  end

  context 'when the image is medium' do
    it 'puts the image in the medium queue' do
      gend_image = FactoryGirl.create(:gend_image)
      gend_image.src_image.size = 575_488
      gend_image.src_image.save!
      GendImageProcessJob.perform_later(gend_image.id)
      expect(enqueued_jobs.first[:queue]).to eq('gend_image_process_medium')
    end
  end

  context 'when the image is large' do
    it 'puts the image in the large queue' do
      gend_image = FactoryGirl.create(:gend_image)
      gend_image.src_image.size = 5_767_168
      gend_image.src_image.save!
      GendImageProcessJob.perform_later(gend_image.id)
      expect(enqueued_jobs.first[:queue]).to eq('gend_image_process_large')
    end
  end

  context 'when the image is very large' do
    it 'puts the image in the shitload queue' do
      gend_image = FactoryGirl.create(:gend_image)
      gend_image.src_image.size = 10_485_761
      gend_image.src_image.save!
      GendImageProcessJob.perform_later(gend_image.id)
      expect(enqueued_jobs.first[:queue]).to eq('gend_image_process_shitload')
    end
  end
end
