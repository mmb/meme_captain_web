module MemeCaptainWeb
  # Converts image data blobs into Magick::ImageLists.
  class ImgBlobLoader
    def initialize(options = {})
      @validator = options[:validator] || ImgFormatValidator.new
    end

    def load_blob(img_data)
      unless @validator.valid?(img_data)
        raise Error::UnsupportedImageFormatError
      end
      Magick::ImageList.new.from_blob(img_data)
    end
  end
end
