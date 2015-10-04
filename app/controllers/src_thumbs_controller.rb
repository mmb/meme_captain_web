# encoding: UTF-8

# Source image thumbnails controller.
class SrcThumbsController < ApplicationController
  def show
    src_thumb = SrcThumb.find(params[:id])

    cache_expires 1.week

    headers['Content-Length'.freeze] = src_thumb.size

    return unless stale?(src_thumb)
    render text: src_thumb.image, content_type: src_thumb.content_type
  end
end
