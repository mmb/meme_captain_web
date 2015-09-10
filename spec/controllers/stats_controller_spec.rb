# encoding: UTF-8

require 'rails_helper'

describe StatsController, type: :controller do
  include StatsD::Instrument::Matchers

  describe "POST 'create'" do
    context 'when the secret matches' do
      let(:stats_secret) { 'stats_secret' }

      it 'sends a stat to statsd' do
        expect do
          post(:create, key: 'test.key', secret: stats_secret)
        end.to trigger_statsd_increment('test.key')
      end

      it 'returns ok' do
        post(:create, key: 'test.key', secret: stats_secret)
        expect(response).to be_ok
      end
    end

    context 'when the secret does not match' do
      let(:stats_secret) { 'wrong_secret' }

      it 'does not send a stat to statsd' do
        expect do
          post(:create, key: 'test.key', secret: stats_secret)
        end.to_not trigger_statsd_increment('test.key')
      end

      it 'returns forbidden' do
        post(:create, key: 'test.key', secret: stats_secret)
        expect(response).to be_forbidden
      end
    end

    context 'when the secret is not configured' do
      let(:stats_secret) { '' }

      before do
        rails = double('rails')
        stub_const('Rails', rails)
        application = double('application')
        allow(rails).to receive(:application).and_return(application)
        secrets = double('secrets')
        allow(application).to receive(:secrets).and_return(secrets)
        allow(secrets).to receive(:stats_secret).and_return('')
      end

      it 'does not send a stat to statsd' do
        expect do
          post(:create, key: 'test.key', secret: stats_secret)
        end.to_not trigger_statsd_increment('test.key')
      end

      it 'returns forbidden' do
        post(:create, key: 'test.key', secret: stats_secret)
        expect(response).to be_forbidden
      end
    end
  end
end
