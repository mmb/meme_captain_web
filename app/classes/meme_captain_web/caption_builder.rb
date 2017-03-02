module MemeCaptainWeb
  # Build the default captions for a gend image.
  class CaptionBuilder
    def build(gend_image)
      if gend_image.src_image.captions.empty?
        return build_default_captions(gend_image)
      end
      build_src_image_default_captions(gend_image)
    end

    private

    def build_src_image_default_captions(gend_image)
      gend_image.src_image.captions.position_order.each do |c|
        gend_image.captions.build(
          top_left_x_pct: c.top_left_x_pct,
          top_left_y_pct: c.top_left_y_pct,
          width_pct: c.width_pct,
          height_pct: c.height_pct,
          text: c.text
        )
      end
    end

    def build_default_captions(gend_image)
      gend_image.captions.build(top_coords)
      gend_image.captions.build(bottom_coords)
    end

    def top_coords
      {
        top_left_x_pct: 0.05,
        top_left_y_pct: 0,
        width_pct: 0.9,
        height_pct: 0.25
      }
    end

    def bottom_coords
      {
        top_left_x_pct: 0.05,
        top_left_y_pct: 0.75,
        width_pct: 0.9,
        height_pct: 0.25
      }
    end
  end
end
