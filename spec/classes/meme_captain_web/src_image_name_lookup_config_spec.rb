# encoding: UTF-8

require 'rails_helper'

describe MemeCaptainWeb::SrcImageNameLookupConfig do
  describe '#configure' do
    let(:x) { double(:x) }
    # This does not work as an instance double.
    let(:config) { double(Rails::Application::Configuration, x: x) }

    context 'when SRC_IMAGE_NAME_LOOKUP_HOST is not set in the environment' do
      let(:env) { {} }

      it 'sets the src image name lookup host to nil' do
        expect(x).to receive(:src_image_name_lookup_host=).with(nil)
        MemeCaptainWeb::SrcImageNameLookupConfig.new.configure(config, env)
      end
    end

    context 'when SRC_IMAGE_NAME_LOOKUP_HOST is empty in the environment' do
      let(:env) { { 'SRC_IMAGE_NAME_LOOKUP_HOST' => '' } }

      it 'sets the src image name lookup host to nil' do
        expect(x).to receive(:src_image_name_lookup_host=).with(nil)
        MemeCaptainWeb::SrcImageNameLookupConfig.new.configure(config, env)
      end
    end

    context 'when SRC_IMAGE_NAME_LOOKUP_HOST is set in the environment' do
      let(:env) { { 'SRC_IMAGE_NAME_LOOKUP_HOST' => 'test.com' } }

      it 'sets the src image name lookup host' do
        expect(x).to receive(:src_image_name_lookup_host=).with('test.com')
        MemeCaptainWeb::SrcImageNameLookupConfig.new.configure(config, env)
      end
    end
  end
end
