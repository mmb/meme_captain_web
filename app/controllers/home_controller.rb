class HomeController < ApplicationController

  PER_ROW = 7

  def index
    @src_images = SrcImage.without_image.includes(:src_thumb).public.active.most_used(2 * PER_ROW)
    @src_sets = SrcSet.front_page.active.not_empty.most_recent(2 * PER_ROW)
    @gend_images = GendImage.without_image.includes(:gend_thumb).public.active.finished.most_recent(3 * PER_ROW)
  end

end
