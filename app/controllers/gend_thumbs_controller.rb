class GendThumbsController < ApplicationController

  def show
    gend_thumb = GendThumb.find(params[:id])

    render :text => gend_thumb.image, :content_type => gend_thumb.content_type
  end

end
