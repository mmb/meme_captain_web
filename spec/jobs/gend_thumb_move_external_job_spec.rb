require 'rails_helper'

describe GendThumbMoveExternalJob do
  subject(:gend_thumb_move_external_job) do
    GendThumbMoveExternalJob.new(gend_thumb.id, 'test-image-bucket')
  end

  let(:gend_thumb) { FactoryGirl.create(:gend_thumb) }

  before do
    expect(GendThumb).to receive(:find).with(gend_thumb.id).and_return(
      gend_thumb
    )
  end

  it 'moves the image to external storage' do
    expect(gend_thumb).to receive(:move_image_external).with(
      'test-image-bucket'
    )
    gend_thumb_move_external_job.perform
  end
end
