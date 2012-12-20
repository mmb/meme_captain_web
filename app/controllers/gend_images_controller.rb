class GendImagesController < ApplicationController

  def new
    @gend_image = GendImage.new
    @gend_image.src_image_id = params[:src_image_id]
  end

  def index
    @gend_images = current_user.gend_images
  end

  def create
    @gend_image = GendImage.new(params[:gend_image])

    # TODO check if current user has access to the source image

    @gend_image.image = MemeCaptain.meme_top_bottom(
      @gend_image.src_image.image, params[:text1], params[:text2],
      :font => MemeCaptainWeb::Config::Font).to_blob

    if @gend_image.save
      redirect_to :action => :show, :id => @gend_image.id
    else
      render :new
    end
  end

  def show
    gend_image = GendImage.find(params[:id])

    render :text => gend_image.image, :content_type => gend_image.content_type
  end

end
