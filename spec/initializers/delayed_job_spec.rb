require 'rails_helper'

describe 'delayed job initializer' do
  it 'sets max_attempts to 4' do
    expect(Delayed::Worker.max_attempts).to eq(4)
  end

  it 'sets destroy_failed_jobs to false' do
    expect(Delayed::Worker.destroy_failed_jobs).to be(false)
  end
end
