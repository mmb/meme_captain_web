describe 'monitrc.erb' do
  let(:output) do
    monitrc_path = File.expand_path('../../../docker/monitrc.erb', __FILE__)
    ERB.new(File.read(monitrc_path)).result(binding)
  end

  describe 'delayed job workers' do
    context 'when the NUM_DELAYED_JOB_WORKERS environment variable is not ' \
      'set' do
      before { stub_const('ENV', {}) }

      it 'starts 1 delayed job worker' do
        expect(output.scan('check process delayed_job.').size).to eq(1)
      end
    end

    context 'when the NUM_DELAYED_JOB_WORKERS environment variable is empty' do
      before { stub_const('ENV', 'NUM_DELAYED_JOB_WORKERS' => '') }

      it 'starts 0 delayed job workers' do
        expect(output.scan('check process delayed_job.').size).to eq(0)
      end
    end

    context 'when the NUM_DELAYED_JOB_WORKERS environment variable is set' do
      before { stub_const('ENV', 'NUM_DELAYED_JOB_WORKERS' => '13') }

      it 'starts that number of delayed job workers' do
        expect(output.scan('check process delayed_job.').size).to eq(13)
      end
    end
  end
end
