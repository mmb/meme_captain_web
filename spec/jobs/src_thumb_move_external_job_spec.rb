require 'rails_helper'

describe SrcThumbMoveExternalJob do
  subject(:src_thumb_move_external_job) do
    SrcThumbMoveExternalJob.new(src_thumb.id, 'test-image-bucket')
  end

  let(:src_thumb) { FactoryGirl.create(:src_thumb) }

  before do
    expect(SrcThumb).to receive(:find).with(src_thumb.id).and_return(src_thumb)
  end

  it 'moves the image to external storage' do
    expect(src_thumb).to receive(:move_image_external).with(
      'test-image-bucket'
    )
    src_thumb_move_external_job.perform
  end
end
