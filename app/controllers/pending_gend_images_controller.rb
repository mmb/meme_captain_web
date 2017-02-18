# Pending generated (meme) images controller.
class PendingGendImagesController < ApplicationController
  include GendImagesHelper

  def show
    gend_image = GendImage.without_image.active.find_by!(id_hash: params[:id])
    if gend_image.work_in_progress?
      render(json:
        {
          created_at: gend_image.created_at,
          error: gend_image.error
        })
    else
      redirect_to(gend_image_url_for(gend_image), status: :see_other)
    end
  end
end
