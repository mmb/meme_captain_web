require 'rails_helper'

describe SrcImageCalcHashJob do
  subject(:src_image_calc_hash_job) { SrcImageCalcHashJob.new(src_image.id) }
  let(:src_image) { FactoryGirl.create(:src_image) }

  it 'calculates a hash of the image data and saves the record' do
    expect do
      src_image_calc_hash_job.perform
      src_image.reload
    end.to change { src_image.image_hash }.to(
      '8bb295b79d039aa6477d3a805ba9579a8a578edc180c099d783b9e8369fc0352'
    )
  end
end
