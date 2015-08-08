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

  describe 'job queues' do
    context 'when the JOB_QUEUES environment variable is not set' do
      before { stub_const('ENV', {}) }

      it 'does not pass the --queues argument to delayed job start' do
        expect(output).to include(
          "/app/script/delayed_job start --pid-dir=/var/run --identifier=0\"\n")
      end
    end

    context 'when the JOB_QUEUES environment variable is empty' do
      before { stub_const('ENV', 'JOB_QUEUES' => '') }

      it 'does not pass the --queues argument to delayed job start' do
        expect(output).to include(
          "/app/script/delayed_job start --pid-dir=/var/run --identifier=0\"\n")
      end
    end

    context 'when the JOB_QUEUES environment variable is set' do
      before { stub_const('ENV', 'JOB_QUEUES' => 'q1,q2,q3') }

      it 'passes the --queues argument to delayed job start' do
        expect(output).to include(
          '/app/script/delayed_job start --pid-dir=/var/run --identifier=0 ' \
          "--queues=q1,q2,q3\"\n")
      end
    end
  end
end
