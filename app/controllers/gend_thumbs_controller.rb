# frozen_string_literal: true

# Generated (meme) image thumbnails controller.
class GendThumbsController < ApplicationController
  def show
    gend_thumb = GendThumb.select(:image).find(params[:id])

    cache_expires(1.year)

    return unless stale?(gend_thumb)
    make_headers(gend_thumb)
    render(body: gend_thumb.image)
  end

  private

  def make_headers(gend_thumb)
    headers.update('Content-Length'.freeze => gend_thumb.size,
                   'Content-Type'.freeze => gend_thumb.content_type)
  end
end
