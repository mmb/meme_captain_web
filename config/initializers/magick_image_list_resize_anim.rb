module Magick

  class ImageList

    def resize_to_fit_anim!(*args)
      if animated?
        new_img = coalesce
        new_img.each { |frame| frame.resize_to_fit!(*args) }
        replace new_img.optimize_layers(Magick::OptimizeLayer)
      else
        resize_to_fit! *args
      end
    end

    def resize_to_fill_anim(*args)
      if animated?
        new_img = coalesce
        new_img.each { |frame| frame.resize_to_fill!(*args) }
        new_img.optimize_layers(Magick::OptimizeLayer)
      else
        resize_to_fill *args
      end
    end

    def animated?
      size > 1
    end

  end

end