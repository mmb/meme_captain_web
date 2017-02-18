module Api
  module V3
    # Pending src images controller.
    class PendingSrcImagesController < ApplicationController
      include SrcImagesHelper

      def show
        src_image = SrcImage.without_image.active.find_by!(id_hash: params[:id])
        render(json:
          {
            created_at: src_image.created_at,
            error: src_image.error,
            in_progress: src_image.work_in_progress? && src_image.error.nil?,
            url: url(src_image)
          })
      end

      private

      def url(src_image)
        src_image_url_for(src_image) unless src_image.work_in_progress?
      end
    end
  end
end
