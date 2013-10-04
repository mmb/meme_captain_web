# encoding: UTF-8

require 'spec_helper'

describe MemeCaptainWeb::Config do

  context 'when the MC_SET_FRONT_PAGE_MIN_QUALITY env var is not set' do

    it 'uses the default' do
      expect(MemeCaptainWeb::Config::SetFrontPageMinQuality).to eq 0
    end

  end

  context 'when the MC_SET_FRONT_PAGE_MIN_QUALITY env var is set' do

    it 'uses the environment variable' do
      pending
    end

  end

end
