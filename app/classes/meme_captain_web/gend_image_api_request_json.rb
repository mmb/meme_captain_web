module MemeCaptainWeb
  # Generate API request JSON that created a gend image.
  class GendImageApiRequestJson
    def initialize(gend_image)
      @gend_image = gend_image
    end

    def json
      JSON.pretty_generate(
        private: @gend_image.private,
        src_image_id: @gend_image.src_image.id_hash,
        captions_attributes: captions
      )
    end

    private

    def captions
      @gend_image.captions.map do |caption|
        {
          text: caption.text,
          top_left_x_pct: caption.top_left_x_pct,
          top_left_y_pct: caption.top_left_y_pct,
          width_pct: caption.width_pct,
          height_pct: caption.height_pct
        }
      end
    end
  end
end
