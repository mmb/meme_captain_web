# encoding: UTF-8

class SrcThumbsController < ApplicationController
  def show
    src_thumb = SrcThumb.find(params[:id])

    cache_expires 1.week

    if stale?(src_thumb)
      render text: src_thumb.image, content_type: src_thumb.content_type
    end
  end
end
