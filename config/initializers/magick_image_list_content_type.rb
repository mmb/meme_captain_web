# encoding: UTF-8

module Magick
  # Helper for getting the content type of the image.
  class ImageList
    def content_type
      {
        'WEBP' => 'image/webp',
        'BMP' => 'image/bmp',
        'BMP2' => 'image/bmp',
        'BMP3' => 'image/bmp',
        'GIF' => 'image/gif',
        'JPEG' => 'image/jpeg',
        'PNG' => 'image/png'
      }.fetch(format)
    end

    def format
      first.format
    end
  end
end
