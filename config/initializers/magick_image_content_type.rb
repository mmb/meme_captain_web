module Magick

  class Image

    def content_type
      {
        'PNG' => 'image/png',
        'GIF' => 'image/gif',
        'JPEG' => 'image/jpeg',
      }.fetch(format)
    end

  end

end
