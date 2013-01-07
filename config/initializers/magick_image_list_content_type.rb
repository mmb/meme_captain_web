module Magick

  class ImageList

    def content_type
      {
          'PNG' => 'image/png',
          'GIF' => 'image/gif',
          'JPEG' => 'image/jpeg',
      }.fetch(format)
    end

    def format
      first.format
    end

  end

end
