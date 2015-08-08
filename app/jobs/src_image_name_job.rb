# Job to automatically name source images using Google.
class SrcImageNameJob < ActiveJob::Base
  queue_as :src_image_name

  def perform(src_image_id)
    return unless Rails.configuration.x.src_image_name_lookup_host
    src_image = SrcImage.find(src_image_id)
    return if src_image.private?
    return if src_image.name?

    conn = create_connection

    conn.get('/imghp?hl=en&tab=wi'.freeze)

    response = conn.get(
      '/searchbyimage'.freeze,
      image_url: src_image_url(src_image))

    name = extract_name(response.body)
    src_image.update!(name: name) if name.present?
  end

  private

  def create_connection
    Faraday.new(url: 'http://google.com'.freeze) do |faraday|
      faraday.use(:cookie_jar)
      faraday.use(FaradayMiddleware::FollowRedirects)
      faraday.headers['User-Agent'.freeze] = \
        'Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20100101 Firefox/8.0'.freeze
      faraday.adapter(Faraday.default_adapter)
    end
  end

  def src_image_url(src_image)
    Rails.application.routes.url_helpers.url_for(
      host: Rails.configuration.x.src_image_name_lookup_host,
      controller: :src_images, action: :show, id: src_image.id_hash)
  end

  def extract_name(body)
    match = body.match(%r{Best guess for this image:.*?>(.+?)</a>})
    match.captures[0] if match
  end
end
