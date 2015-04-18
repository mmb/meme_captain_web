# encoding: UTF-8

# Generated (meme) image pages controller.
class GendImagePagesController < ApplicationController
  include GendImagesHelper

  def show
    @gend_image = GendImage.find_by_id_hash_and_is_deleted!(params[:id], false)

    @src_image = SrcImage.without_image.find(@gend_image.src_image_id)
    @gend_image_url = gend_image_url_for(@gend_image)

    # rubocop:disable Style/GuardClause
    if @gend_image.work_in_progress? &&
       (Time.now - @gend_image.created_at < 10)
      @refresh_in = 2
    end
    # rubocop:enable Style/GuardClause
  end
end
