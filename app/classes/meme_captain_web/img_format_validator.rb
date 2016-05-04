module MemeCaptainWeb
  # Validate that data contains a supported image format.
  class ImgFormatValidator
    def valid?(img_data)
      jpeg?(img_data) ||
        gif?(img_data) ||
        png?(img_data) ||
        bmp?(img_data) ||
        svg?(img_data) ||
        webp?(img_data)
    end

    private

    def jpeg?(img_data)
      start_with_bytes?(img_data, [0xff, 0xd8])
    end

    def gif?(img_data)
      start_with_bytes?(img_data, [0x47, 0x49, 0x46, 0x38])
    end

    def png?(img_data)
      start_with_bytes?(
        img_data, [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])
    end

    def bmp?(img_data)
      start_with_bytes?(img_data, [0x42, 0x4d])
    end

    def svg?(img_data)
      start_with_bytes?(img_data, [0x3c, 0x3f, 0x78, 0x6d, 0x6c])
    end

    def webp?(img_data)
      start_with_bytes?(img_data, [0x52, 0x49, 0x46, 0x46]) &&
        img_data.byteslice(8, 4).bytes == [0x57, 0x45, 0x42, 0x50]
    end

    def start_with_bytes?(img_data, bytes)
      img_data.byteslice(0, bytes.size).bytes == bytes
    end
  end
end
