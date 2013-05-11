module MemeCaptainWeb

  module Config

    # Maximum size of any side for generated thumbnail images.
    ThumbSide = 128

    # Maximum size of any side for source images.
    SourceImageSide = 800

    SetFrontPageMinQuality = (ENV['SET_FRONT_PAGE_MIN_QUALITY'] || 0).to_i
  end

end
