# encoding: UTF-8

# Generated (meme) image thumbnails controller.
class GendThumbsController < ApplicationController
  def show
    gend_thumb = GendThumb.find(params[:id], select: :image)

    cache_expires 1.week

    return unless stale?(gend_thumb)
    render text: gend_thumb.image, content_type: gend_thumb.content_type
  end
end
