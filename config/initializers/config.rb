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
    # Default font to use for non ascii text.
    DefaultUnicodeFont = ENV['MC_DEFAULT_UNICODE_FONT'].blank? ? 'FreeSerif.otf' : ENV['MC_DEFAULT_UNICODE_FONT']

    GendImageHost = ENV['GEND_IMAGE_HOST'].blank? ? nil : ENV['GEND_IMAGE_HOST']
  end

end
