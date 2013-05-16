class MyController < ApplicationController

  def show
    return if not_logged_in

    @src_sets = SrcSet.owned_by(current_user).active.most_recent.page(params[:page])
    @src_images = SrcImage.without_image.includes(:src_thumb).owned_by(current_user).active.most_recent.page(params[:page])
    @gend_images = GendImage.without_image.includes(:gend_thumb).owned_by(current_user).active.most_recent.page(params[:page])
  end

end
