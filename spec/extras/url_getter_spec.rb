require 'spec_helper'

describe UrlGetter do

  describe '#get' do

    it 'fetches the URL and returns a blob' do
      stub_request(:get, 'http://example.com/').to_return(body: 'body')

      url_getter = UrlGetter.new

      expect(url_getter.get('http://example.com/')).to eq 'body'
    end

  end

end
