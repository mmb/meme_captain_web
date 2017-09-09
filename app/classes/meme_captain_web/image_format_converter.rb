# frozen_string_literal: true

module MemeCaptainWeb
  # Change the format of the passed in Magick::ImageList based on a map.
  class ImageFormatConverter
    def convert(image)
      conversions = {
        'SVG' => 'PNG'
      }
      new_format = conversions[image.format]
      image.format = new_format if new_format
    end
  end
end
