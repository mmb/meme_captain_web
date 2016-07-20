# encoding: UTF-8

# Generated (meme) image pages controller.
class GendImagePagesController < ApplicationController
  include GendImagesHelper

  def show
    @gend_image = GendImage.without_image.active.find_by!(
      id_hash: params[:id]
    )

    @src_image = SrcImage.without_image.find(@gend_image.src_image_id)
    @gend_image_url = gend_image_url_for(@gend_image)
    @show_creator_ip = admin?

    set_refresh
  end

  private

  def set_refresh
    return unless @gend_image.work_in_progress?
    @refresh_in = 2 if Time.now - @gend_image.created_at < 10
  end
end
