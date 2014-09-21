# encoding: UTF-8

# Home page controller.
class HomeController < ApplicationController
  def index
    @src_images = SrcImage.without_image.includes(
        :src_thumb).publick.active.finished.most_used(12)
    @src_sets = SrcSet.front_page.active.not_empty.most_recent(12)
    @gend_images = GendImage.without_image.includes(
        :gend_thumb).publick.active.finished.most_recent(24)

    @show_toolbar = false
  end
end
