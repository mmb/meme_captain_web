class GendImagesController < ApplicationController

  def new
    @gend_image = GendImage.new
    @gend_image.src_image_id = params[:src_image_id]
  end

  def index
    @gend_images = current_user.gend_images
  end

  def create
    src_image = SrcImage.find_by_id_hash!(params[:gend_image][:src_image_id])

    @gend_image = GendImage.new
    @gend_image.src_image = src_image

    @gend_image.image = MemeCaptain.meme_top_bottom(src_image.image,
      params[:text1], params[:text2],
      :font => MemeCaptainWeb::Config::Font).to_blob

    if @gend_image.save
      redirect_to :action => :show, :id => @gend_image.id_hash
    else
      render :new
    end
  end

  def show
    gend_image = GendImage.find_by_id_hash!(params[:id])

    render :text => gend_image.image, :content_type => gend_image.content_type
  end

end
