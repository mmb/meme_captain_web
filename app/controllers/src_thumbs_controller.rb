class SrcThumbsController < ApplicationController

  def show
    src_thumb = SrcThumb.find(params[:id])

    expires_in 1.hour, :public => true

    if stale?(src_thumb)
      render :text => src_thumb.image, :content_type => src_thumb.content_type
    end
  end

end
