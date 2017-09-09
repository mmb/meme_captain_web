# frozen_string_literal: true

# Source image thumbnails controller.
class SrcThumbsController < ApplicationController
  def show
    src_thumb = SrcThumb.find(params[:id])

    cache_expires(1.year)

    return unless stale?(src_thumb)
    make_headers(src_thumb)

    body = src_thumb.image_external_body
    if body
      self.response_body = body
    else
      render(body: src_thumb.image)
    end
  end

  private

  def make_headers(src_thumb)
    headers.update('Content-Length' => src_thumb.size,
                   'Content-Type' => src_thumb.content_type)
  end
end
