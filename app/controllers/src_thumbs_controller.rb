class SrcThumbsController < ApplicationController

  def show
    src_thumb = SrcThumb.find(params[:id])

    render :text => src_thumb.image, :content_type => src_thumb.content_type
  end

end
