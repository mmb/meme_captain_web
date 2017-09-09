# frozen_string_literal: true

module Api
  module V3
    # Pending gend images controller.
    class PendingGendImagesController < ApplicationController
      include GendImagesHelper

      def show
        gend_image = GendImage.without_image.active.find_by!(
          id_hash: params[:id]
        )
        render(json:
          {
            created_at: gend_image.created_at,
            error: gend_image.error,
            in_progress: gend_image.work_in_progress? && gend_image.error.nil?,
            url: url(gend_image)
          })
      end

      private

      def url(gend_image)
        gend_image_url_for(gend_image) unless gend_image.work_in_progress?
      end
    end
  end
end
