class GendImagePagesController < ApplicationController

  def show
    @gend_image = GendImage.without_image.find_by_id_hash!(params[:id])
    @src_image = SrcImage.without_image.find(@gend_image.src_image_id)
    @gend_image_url = url_for(
        :controller => :gend_images, :action => :show, :id => @gend_image.id_hash, :format => @gend_image.format)

    if @gend_image.work_in_progress? && (Time.now() - @gend_image.created_at < 10)
      @refresh_in = 2
    end
  end
end
