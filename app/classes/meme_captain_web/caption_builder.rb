module MemeCaptainWeb
  # Build the default captions for a gend image.
  class CaptionBuilder
    def build(gend_image)
      gend_image.captions.build(top_coords)
      gend_image.captions.build(bottom_coords)
    end

    private

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
