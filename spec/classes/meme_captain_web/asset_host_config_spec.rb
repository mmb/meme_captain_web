# encoding: UTF-8

require 'rails_helper'

describe MemeCaptainWeb::AssetHostConfig do
  describe '#configure' do
    # This does not work as an instance double.
    let(:config) { double(Rails::Application::Configuration) }

    context 'when ASSET_DOMAIN is not set in the environment' do
      let(:env) { {} }

      it 'does not set the asset host' do
        MemeCaptainWeb::AssetHostConfig.new.configure(config, env)
        allow(config).to receive(:action_controller)
        expect(config).to_not have_received(:action_controller)
      end
    end

    context 'when ASSET_DOMAIN is empty in the environment' do
      let(:env) { { 'ASSET_DOMAIN' => '' } }

      it 'does not set the asset host' do
        MemeCaptainWeb::AssetHostConfig.new.configure(config, env)
        allow(config).to receive(:action_controller)
        expect(config).to_not have_received(:action_controller)
      end
    end

    context 'when ASSET_DOMAIN is set in the environment' do
      let(:env) { { 'ASSET_DOMAIN' => 'myassets.com' } }

      it 'sets the asset host to a proc' do
        action_controller = double('action_controller')
        expect(config).to receive(:action_controller).and_return(
          action_controller)
        request = instance_double('ActionController::Request')
        allow(request).to receive(:protocol).and_return('protocol://')
        expect(action_controller).to receive(:'asset_host=') do |p|
          expect(p.call('asset1.gif', request)).to eq(
            'protocol://a2.myassets.com')
        end

        MemeCaptainWeb::AssetHostConfig.new.configure(config, env)
      end
    end
  end
end
