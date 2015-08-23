require 'rails_helper'

describe 'delayed job initializer' do
  it 'sets max_attempts to 4' do
    expect(Delayed::Worker.max_attempts).to eq(4)
  end

  it 'sets destroy_failed_jobs to false' do
    expect(Delayed::Worker.destroy_failed_jobs).to be(false)
  end

  it 'sets max_run_time to 90 seconds' do
    expect(Delayed::Worker.max_run_time).to eq(90.seconds)
  end

  context 'delay_jobs' do
    let(:rb_path) do
      File.expand_path(
        '../../../config/initializers/delayed_job.rb', __FILE__)
    end

    context 'when the DELAY_JOBS environment variable is not set to false' do
      before { stub_const('ENV', {}) }
      it 'does not change the value of delay_jobs' do
        expect do
          Kernel.silence_warnings { load(rb_path) }
        end.to_not change { Delayed::Worker.delay_jobs }
      end
    end

    context 'when the DELAY_JOBS environment variable is set to false' do
      before { stub_const('ENV', 'DELAY_JOBS' => 'false') }

      it 'sets delay_jobs to false' do
        expect(Delayed::Worker.delay_jobs).to eq(false)
      end
    end
  end
end
