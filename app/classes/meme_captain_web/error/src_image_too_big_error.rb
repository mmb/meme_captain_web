module MemeCaptainWeb
  module Error
    # Error subclass for src images that are too big.
    class SrcImageTooBigError < StandardError
      include ActionView::Helpers::NumberHelper

      def initialize(bytes = nil)
        message = 'image is too large'
        message << " (#{number_to_human_size(bytes)})" if bytes
        super(message)
      end
    end
  end
end
