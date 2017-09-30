# frozen_string_literal: true

#
module MemeCaptainWeb
  # Name images using Google search by image.
  class GoogleImageNamer
    def name(image_url)
      conn = create_connection

      conn.get('/imghp')

      response = conn.get('/searchbyimage', image_url: image_url)

      extract_name(response.body)
    end

    private

    def create_connection
      Faraday.new(url: 'https://images.google.com') do |faraday|
        faraday.use(:cookie_jar)
        faraday.use(FaradayMiddleware::FollowRedirects)
        faraday.headers['User-Agent'] = \
          'Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20100101 ' \
          'Firefox/8.0'
        faraday.adapter(Faraday.default_adapter)
      end
    end

    def extract_name(body)
      match = body.match(%r{Best guess for this image:.*?>(.+?)</a>})
      # rubocop:disable Lint/SafeNavigationChain
      match&.captures[0]
      # rubocop:enable Lint/SafeNavigationChain
    end
  end
end
