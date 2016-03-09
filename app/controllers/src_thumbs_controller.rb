# encoding: UTF-8
# frozen_string_literal: true

# Source image thumbnails controller.
class SrcThumbsController < ApplicationController
  def show
    src_thumb = SrcThumb.find(params[:id])

    cache_expires 1.week

    headers['Content-Length'.freeze] = src_thumb.size

    return unless stale?(src_thumb)
    headers['Content-Type'.freeze] = src_thumb.content_type
    render(text: src_thumb.image)
  end
end
