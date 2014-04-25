# encoding: UTF-8

module Magick
  # Helper for getting the content type of the image.
  class ImageList
    def content_type
      {
        'PNG' => 'image/png',
        'GIF' => 'image/gif',
        'JPEG' => 'image/jpeg'
      }.fetch(format)
    end

    def format
      first.format
    end
  end
end
