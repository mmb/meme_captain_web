# frozen_string_literal: true

# Build urls for source images.
module SrcImagesHelper
  def src_image_url_for(src_image)
    url_for(
      controller: '/src_images'.freeze,
      action: :show,
      id: src_image.id_hash,
      format: src_image.format,
      host: MemeCaptainWeb::Config::GEND_IMAGE_HOST || request.host
    )
  end

  def src_thumb_url_for(src_image)
    url_for(
      controller: :src_thumbs,
      action: :show,
      id: src_image.src_thumb.id,
      format: src_image.src_thumb.format
    )
  end
end
