# encoding: UTF-8

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
    SrcImage.without_image.includes(
      :src_thumb).publick.active.finished.most_used(12)
  end

  def src_sets
    SrcSet.front_page.active.not_empty.most_recent(12)
  end

  def gend_images
    GendImage.without_image.includes(
      :gend_thumb).publick.active.finished.most_recent(24)
  end
end
