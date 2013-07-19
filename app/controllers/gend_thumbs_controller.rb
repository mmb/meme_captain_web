# encoding: UTF-8

class GendThumbsController < ApplicationController

  def show
    gend_thumb = GendThumb.find(params[:id], select: :image)

    expires_in 1.hour, public: true

    if stale?(gend_thumb)
      render text: gend_thumb.image, content_type: gend_thumb.content_type
    end
  end

end
