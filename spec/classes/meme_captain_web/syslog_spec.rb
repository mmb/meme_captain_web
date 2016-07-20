require 'rails_helper'

describe 'MemeCaptainWeb::Syslog' do
  subject(:syslog) { MemeCaptainWeb::Syslog.new }

  describe '#logger' do
    context 'when the SYSLOG environment variable is not set' do
      let(:env) { {} }

      it 'returns nil' do
        expect(syslog.logger(env, 'program')).to be_nil
      end
    end

    context 'when the SYSLOG environment variable is empty' do
      let(:env) { { 'SYSLOG' => '' } }

      it 'returns nil' do
        expect(syslog.logger(env, 'program')).to be_nil
      end
    end

    context 'when the SYSLOG environment variable is set' do
      let(:env) { { 'SYSLOG' => 'localhost:514' } }

      it 'returns a syslog logger' do
        remote_syslog_logger = instance_double(RemoteSyslogLogger)
        expect(RemoteSyslogLogger).to receive(:new).with(
          'localhost', 514, program: 'program'
        ).and_return(remote_syslog_logger)
        expect(syslog.logger(env, 'program')).to eq(remote_syslog_logger)
      end
    end
  end
end
