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
        headers: { 'Location' => 'http://example.com/2' }
      )
      stub_request(:get, 'http://example.com/2').to_return(body: 'body')

      url_getter = MemeCaptainWeb::UrlGetter.new

      expect(url_getter.get('http://example.com/')).to eq 'body'
    end

    it 'raises an error if the HTTP response is an error response' do
      stub_request(:get, 'http://example.com/').to_return(status: 404)

      url_getter = MemeCaptainWeb::UrlGetter.new

      expect { url_getter.get('http://example.com/') }.to raise_error(
        Faraday::ResourceNotFound
      )
    end

    context 'when the URL is not ASCII' do
      it 'fetches the URL and returns a blob' do
        stub_request(:get, 'http://exámple.com/').to_return(body: 'body')

        url_getter = MemeCaptainWeb::UrlGetter.new

        expect(url_getter.get('http://exámple.com/')).to eq('body')
      end
    end

    describe 'request blocking' do
      it 'blocks requests to 127.0.0.1' do
        url_getter = MemeCaptainWeb::UrlGetter.new

        expect { url_getter.get('http://127.0.0.1/') }
          .to raise_exception(Faraday::RestrictIPAddresses::AddressNotAllowed)
      end

      it 'blocks requests to localhost' do
        url_getter = MemeCaptainWeb::UrlGetter.new

        expect { url_getter.get('http://localhost/') }
          .to raise_exception(Faraday::RestrictIPAddresses::AddressNotAllowed)
      end

      it 'blocks requests to non-routable class C' do
        url_getter = MemeCaptainWeb::UrlGetter.new

        expect { url_getter.get('http://192.168.0.2/') }
          .to raise_exception(Faraday::RestrictIPAddresses::AddressNotAllowed)
      end

      it 'blocks requests to non-routable class B' do
        url_getter = MemeCaptainWeb::UrlGetter.new

        expect { url_getter.get('http://172.16.0.2/') }
          .to raise_exception(Faraday::RestrictIPAddresses::AddressNotAllowed)
      end

      it 'blocks requests to non-routable class A' do
        url_getter = MemeCaptainWeb::UrlGetter.new

        expect { url_getter.get('http://10.0.0.2/') }
          .to raise_exception(Faraday::RestrictIPAddresses::AddressNotAllowed)
      end

      it 'blocks requests to the AWS instance metadata endpoint' do
        url_getter = MemeCaptainWeb::UrlGetter.new

        expect { url_getter.get('http://169.254.169.254/latest/meta-data/') }
          .to raise_exception(Faraday::RestrictIPAddresses::AddressNotAllowed)
      end
    end
  end
end
