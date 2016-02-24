require 'rails_helper'

describe GendImageCalcHashJob do
  subject(:gend_image_calc_hash_job) { GendImageCalcHashJob.new(gend_image.id) }
  let(:gend_image) { FactoryGirl.create(:gend_image) }

  it 'calculates a hash of the image data and saves the record' do
    expect do
      gend_image_calc_hash_job.perform
      gend_image.reload
    end.to change { gend_image.image_hash }.to(
      '8bb295b79d039aa6477d3a805ba9579a8a578edc180c099d783b9e8369fc0352')
  end
end
