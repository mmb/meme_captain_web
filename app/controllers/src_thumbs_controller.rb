# frozen_string_literal: true

# Source image thumbnails controller.
class SrcThumbsController < ApplicationController
  def show
    src_thumb = SrcThumb.select(:image).find(params[:id])

    cache_expires(1.year)

    return unless stale?(src_thumb)
    make_headers(src_thumb)
    render(body: src_thumb.image)
  end

  private

  def make_headers(src_thumb)
    headers.update('Content-Length'.freeze => src_thumb.size,
                   'Content-Type'.freeze => src_thumb.content_type)
  end
end
