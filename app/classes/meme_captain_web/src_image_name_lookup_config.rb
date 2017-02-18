# frozen_string_literal: true

module MemeCaptainWeb
  # Src image name lookup setup.
  class SrcImageNameLookupConfig
    def configure(config, env)
      if env['SRC_IMAGE_NAME_LOOKUP_HOST'.freeze].present?
        config.x.src_image_name_lookup_host = \
          env['SRC_IMAGE_NAME_LOOKUP_HOST'.freeze]
      else
        config.x.src_image_name_lookup_host = nil
      end
    end
  end
end
