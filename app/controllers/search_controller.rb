# encoding: UTF-8

# Search controller.
class SearchController < ApplicationController
  def show
    query = params[:q].try(:strip)

    @src_images = SrcImage.without_image.includes(:src_thumb).name_matches(
        query).publick.active.finished.most_used.page(params[:page])

    @gend_images = GendImage.without_image.includes(:gend_thumb)
      .caption_matches(query).publick.active.finished.most_recent
      .page(params[:page])
  end
end
