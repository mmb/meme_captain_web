# encoding: UTF-8

require 'rails_helper'

describe MemeCaptainWeb::UrlGetter do
  describe '#get' do
    it 'fetches the URL and returns a blob' do
      stub_request(:get, 'http://example.com/').to_return(body: 'body')

      url_getter = MemeCaptainWeb::UrlGetter.new

      expect(url_getter.get('http://example.com/')).to eq 'body'
    end

    it 'follow redirects' do
      stub_request(:get, 'http://example.com/').to_return(
        status: 302,
        headers: { 'Location' => 'http://example.com/2' })
      stub_request(:get, 'http://example.com/2').to_return(body: 'body')

      url_getter = MemeCaptainWeb::UrlGetter.new

      expect(url_getter.get('http://example.com/')).to eq 'body'
    end

    it 'raises an error if the HTTP response is an error response' do
      stub_request(:get, 'http://example.com/').to_return(status: 404)

      url_getter = MemeCaptainWeb::UrlGetter.new

      expect { url_getter.get('http://example.com/') }.to raise_error
    end
  end
end
