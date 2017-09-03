require 'rails_helper'

describe SrcImageMoveExternalJob do
  subject(:src_image_move_external_job) do
    SrcImageMoveExternalJob.new(src_image.id, 'test-image-bucket')
  end

  let(:src_image) { FactoryGirl.create(:src_image) }

  before do
    expect(SrcImage).to receive(:find).with(src_image.id).and_return(src_image)
  end

  it 'moves the image to external storage' do
    expect(src_image).to receive(:move_image_external).with(
      'test-image-bucket'
    )
    src_image_move_external_job.perform
  end
end
