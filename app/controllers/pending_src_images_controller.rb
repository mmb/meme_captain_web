# encoding: UTF-8

# Pending src images controller.
class PendingSrcImagesController < ApplicationController
  include SrcImagesHelper

  def show
    src_image = SrcImage.without_image.active.find_by!(id_hash: params[:id])
    if src_image.work_in_progress?
      render(json: { created_at: src_image.created_at })
    else
      redirect_to(src_image_url_for(src_image), status: :see_other)
    end
  end
end
