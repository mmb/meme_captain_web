# Home page controller.
class HomeController < ApplicationController
  def index
    @src_images = src_images
    @src_sets = src_sets
    @gend_images = gend_images
    @show_toolbar = false
  end

  private

  def src_images
    if admin?
      SrcImage.without_image.includes(:src_thumb).most_used(12)
    else
      SrcImage.without_image.includes(
        :src_thumb
      ).publick.active.finished.most_used(12)
    end
  end

  def src_sets
    SrcSet.front_page.active.not_empty.most_recent(12)
  end

  def gend_images
    if admin?
      GendImage.without_image.includes(:gend_thumb).most_recent(24)
    else
      GendImage.without_image.includes(
        :gend_thumb
      ).publick.active.finished.most_recent(24)
    end
  end
end
