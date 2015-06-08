# encoding: UTF-8

require 'rails_helper'

describe 'Airbrake initializer' do
  context 'when the AIRBRAKE_API_KEY is not set' do
    before do
      stub_const(
        'ENV',
        ENV.to_hash.delete_if { |key| key == 'AIRBRAKE_API_KEY' })
    end

    it 'does not initializes Airbrake' do
      expect(Airbrake).not_to receive(:configure)
      load(
        File.expand_path(
          '../../../config/initializers/airbrake.rb', __FILE__))
    end
  end

  context 'when the AIRBRAKE_API_KEY env var is empty' do
    before do
      stub_const(
        'ENV',
        ENV.to_hash.merge('AIRBRAKE_API_KEY' => ''))
    end

    it 'does not initializes Airbrake' do
      expect(Airbrake).not_to receive(:configure)
      load(
        File.expand_path(
          '../../../config/initializers/airbrake.rb', __FILE__))
    end
  end

  context 'when the AIRBRAKE_API_KEY env var is set' do
    before do
      stub_const(
        'ENV',
        ENV.to_hash.merge('AIRBRAKE_API_KEY' => 'test-api-key'))
    end

    it 'initializes Airbrake' do
      config = instance_double('Airbrake::Configuration')
      expect(Airbrake).to receive(:configure).and_yield(config)
      expect(config).to receive(:api_key=).with('test-api-key')
      load(
        File.expand_path(
          '../../../config/initializers/airbrake.rb', __FILE__))
    end

    it 'enables the delayed job Airbrake plugin' do
      load(
        File.expand_path(
          '../../../config/initializers/airbrake.rb', __FILE__))
      expect(Delayed::Worker.plugins).to include(
        Delayed::Plugins::Airbrake::Plugin)
    end
  end
end
