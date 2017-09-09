# frozen_string_literal: true

# Generated (meme) image thumbnails controller.
class GendThumbsController < ApplicationController
  def show
    gend_thumb = GendThumb.find(params[:id])

    cache_expires(1.year)

    return unless stale?(gend_thumb)
    make_headers(gend_thumb)

    body = gend_thumb.image_external_body
    if body
      self.response_body = body
    else
      render(body: gend_thumb.image)
    end
  end

  private

  def make_headers(gend_thumb)
    headers.update('Content-Length' => gend_thumb.size,
                   'Content-Type' => gend_thumb.content_type)
  end
end
