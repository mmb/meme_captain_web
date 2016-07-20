# encoding: UTF-8
# frozen_string_literal: true

# Build urls for pending generated images.
module PendingGendImagesHelper
  def pending_gend_image_url_for(gend_image)
    url_for(
      controller: :pending_gend_images,
      action: :show,
      id: gend_image.id_hash
    )
  end
end
