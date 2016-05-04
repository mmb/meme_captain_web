module MemeCaptainWeb
  module Error
    # Error subclass for unsupported image format.
    class UnsupportedImageFormatError < StandardError
      def initialize(msg = 'unsupported image format')
        super
      end
    end
  end
end
