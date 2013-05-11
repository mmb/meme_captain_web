require 'spec_helper'

describe MemeCaptainWeb::Config do

  context 'when the SET_FRONT_PAGE_MIN_QUALITY environment variable is not set' do

    it 'uses the default' do
      expect(MemeCaptainWeb::Config::SetFrontPageMinQuality).to eq 0
    end

  end

  context 'when the SET_FRONT_PAGE_MIN_QUALITY environment variable is set' do

    it 'uses the environment variable' do
      pending
    end

  end

end
