# frozen_string_literal: true

#
module MemeCaptainWeb
  # Name images using Google search by image.
  class GoogleImageNamer
    def name(image_url)
      conn = create_connection

      conn.get('/imghp'.freeze)

      response = conn.get('/searchbyimage'.freeze, image_url: image_url)

      extract_name(response.body)
    end

    private

    def create_connection
      Faraday.new(url: 'https://images.google.com'.freeze) do |faraday|
        faraday.use(:cookie_jar)
        faraday.use(FaradayMiddleware::FollowRedirects)
        faraday.headers['User-Agent'.freeze] = \
          'Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20100101 ' \
          'Firefox/8.0'.freeze
        faraday.adapter(Faraday.default_adapter)
      end
    end

    def extract_name(body)
      match = body.match(%r{Best guess for this image:.*?>(.+?)</a>})
      match.captures[0] if match
    end
  end
end
