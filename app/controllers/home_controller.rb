class HomeController < ApplicationController

  def index
    @src_sets = SrcSet.active.most_recent(6)

    if current_user
      @src_images = SrcImage.owned_by(current_user).active.most_recent(6)
      @gend_images = GendImage.owned_by(current_user).active.most_recent(6)
    end

  end

end