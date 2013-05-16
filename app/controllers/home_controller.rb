class HomeController < ApplicationController

  PER_ROW = 7

  def index
    @src_sets = SrcSet.front_page.active.most_recent(2 * PER_ROW)
    @gend_images = GendImage.without_image.includes(:gend_thumb).public.active.finished.most_recent(3 * PER_ROW)
  end

end
