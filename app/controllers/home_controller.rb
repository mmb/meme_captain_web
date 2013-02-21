class HomeController < ApplicationController

  def index
    if current_user
      @src_sets = SrcSet.active.most_recent(8)
      @src_images = SrcImage.without_image.includes(:src_thumb).owned_by(current_user).active.most_recent(6)
      @gend_images = GendImage.without_image.includes(:gend_thumb).owned_by(current_user).active.most_recent(6)
    else
      @src_sets = SrcSet.active.most_recent(16)
    end

  end
end