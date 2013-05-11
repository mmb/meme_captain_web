module MemeCaptainWeb

  module Config

    # Maximum size of any side for generated thumbnail images.
    ThumbSide = 128

    # Maximum size of any side for source images.
    SourceImageSide = 800

    # Minimum source set quality to be shown on the front page.
    SetFrontPageMinQuality = (ENV['MC_SET_FRONT_PAGE_MIN_QUALITY'] || 0).to_i

    # Default font to use for memes.
    DefaultFont = ENV['MC_DEFAULT_FONT'].blank? ? 'Coda-Heavy.ttf' : ENV['MC_DEFAULT_FONT']
  end

end
