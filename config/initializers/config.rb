# encoding: UTF-8

module MemeCaptainWeb
  # Configuration constants.
  module Config
    # Maximum size of any side for generated thumbnail images.
    ThumbSide = 128

    # Source images with any side longer than MaxSourceImageSide will be
    # reduced. After reduction their maximum side will be MaxSourceImageSide.
    MaxSourceImageSide = 800

    # Source images with their longest side shorter than MinSourceImageSide
    # will be enlarged. After enlargement their maximum side will be
    # ENLARGED_SOURCE_IMAGE_SIDE.
    MinSourceImageSide = 400

    ENLARGED_SOURCE_IMAGE_SIDE = 600

    # Minimum source set quality to be shown on the front page.
    SetFrontPageMinQuality = (ENV['MC_SET_FRONT_PAGE_MIN_QUALITY'] || 0).to_i

    GendImageHost =
        ENV['GEND_IMAGE_HOST'].blank? ? nil : ENV['GEND_IMAGE_HOST']
  end
end
