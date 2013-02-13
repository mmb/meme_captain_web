class HomeController < ApplicationController

  def index
    @src_sets = SrcSet.active.most_recent(6)

    if current_user
      @src_images = SrcImage.without_image.includes(:src_thumb).owned_by(current_user).active.most_recent(6)
      @gend_images = GendImage.without_image.includes(:gend_thumb).owned_by(current_user).active.most_recent(6)
    end

  end

end