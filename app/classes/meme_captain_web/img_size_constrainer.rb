# frozen_string_literal: true

module MemeCaptainWeb
  # Reduce or enlarge an image based on configured constraints.
  class ImgSizeConstrainer
    def constrain_size(img)
      longest_side = [img.columns, img.rows].max

      if !img.animated? &&
         longest_side < MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE
        img.resize_to_fit!(MemeCaptainWeb::Config::ENLARGED_SOURCE_IMAGE_SIDE)
      elsif img.columns > MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE ||
            img.rows > MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE
        img.resize_to_fit_anim!(MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE)
      end
    end
  end
end
