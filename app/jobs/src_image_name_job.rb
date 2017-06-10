# frozen_string_literal: true

# Job to automatically name source images using Google.
class SrcImageNameJob
  attr_reader :src_image_id

  def initialize(src_image_id)
    @src_image_id = src_image_id
  end

  def perform
    return unless Rails.configuration.x.src_image_name_lookup_host
    src_image = SrcImage.find(src_image_id)
    return if src_image.private? || src_image.name?

    name = MemeCaptainWeb::GoogleImageNamer.new.name(src_image_url(src_image))
    src_image.update!(name: name) if name.present?
  end

  def max_attempts
    1
  end

  private

  def src_image_url(src_image)
    Rails.application.routes.url_helpers.url_for(
      host: Rails.configuration.x.src_image_name_lookup_host,
      controller: :src_images, action: :show, id: src_image.id_hash
    )
  end
end
