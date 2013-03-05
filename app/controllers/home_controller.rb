class HomeController < ApplicationController

  PER_ROW = 7

  def index
    if current_user
      @src_sets = SrcSet.active.most_recent(PER_ROW)
      @src_images = SrcImage.without_image.includes(:src_thumb).owned_by(current_user).active.most_recent(PER_ROW)
      @gend_images = GendImage.without_image.includes(:gend_thumb).owned_by(current_user).active.most_recent(2 * PER_ROW)
    else
      @src_sets = SrcSet.active.most_recent(2 * PER_ROW)
      @gend_images = GendImage.without_image.includes(:gend_thumb).owned_by(current_user).active.most_recent(3 * PER_ROW)
    end
  end

end