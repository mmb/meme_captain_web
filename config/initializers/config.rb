# encoding: UTF-8

module MemeCaptainWeb
  # Configuration constants.
  module Config
    # Maximum size of any side for generated thumbnail images.
    THUMB_SIDE = 128

    # Source images with any side longer than MAX_SOURCE_IMAGE_SIDE will be
    # reduced. After reduction their maximum side will be MAX_SOURCE_IMAGE_SIDE.
    MAX_SOURCE_IMAGE_SIDE = 800

    # Source images with their longest side shorter than MIN_SOURCE_IMAGE_SIDE
    # will be enlarged. After enlargement their maximum side will be
    # ENLARGED_SOURCE_IMAGE_SIDE.
    MIN_SOURCE_IMAGE_SIDE = 400

    ENLARGED_SOURCE_IMAGE_SIDE = 600

    # Minimum source set quality to be shown on the front page.
    SetFrontPageMinQuality = (ENV['MC_SET_FRONT_PAGE_MIN_QUALITY'] || 0).to_i

    GEND_IMAGE_HOST =
        ENV['GEND_IMAGE_HOST'].blank? ? nil : ENV['GEND_IMAGE_HOST']

    MAX_SRC_IMAGE_SIZE = Rails.application.secrets.max_src_image_size
  end
end
