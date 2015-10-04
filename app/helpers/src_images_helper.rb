# encoding: UTF-8

# Build urls for source images.
module SrcImagesHelper
  def src_image_url_for(src_image)
    url_for(
      controller: :src_images,
      action: :show,
      id: src_image.id_hash,
      format: src_image.format,
      host: MemeCaptainWeb::Config::GEND_IMAGE_HOST || request.host
    )
  end

  def meme_create_url(src_image)
    url_for(
      controller: :gend_images,
      action: :new,
      src: src_image.id_hash,
      host: request.host
    )
  end
end
