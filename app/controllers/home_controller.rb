class HomeController < ApplicationController

  def index
    @src_sets = SrcSet.active.most_recent(8)

    if current_user
      @src_images = SrcImage.owned_by(current_user).active.most_recent(8)
      @gend_images = GendImage.owned_by(current_user).active.most_recent(8)
    end

  end

end