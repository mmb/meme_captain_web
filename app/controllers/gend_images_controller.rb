class GendImagesController < ApplicationController

  def new
    @gend_image = GendImage.new
    @gend_image.src_image = SrcImage.find_by_id_hash!(params[:src])
    2.times { @gend_image.captions.build }
  end

  def index
    @gend_images = GendImage.without_image.includes(:gend_thumb).owned_by(current_user).active.most_recent.page(params[:page])
  end

  def create
    src_image = SrcImage.find_by_id_hash!(params[:gend_image][:src_image_id])

    @gend_image = GendImage.new(params[:gend_image])
    @gend_image.src_image = src_image
    @gend_image.user = current_user

    if @gend_image.save
      redirect_to :action => :index
    else
      render :new
    end
  end

  def show
    gend_image = GendImage.find_by_id_hash!(params[:id])

    render :text => gend_image.image, :content_type => gend_image.content_type
  end

  def destroy
    gend_image = GendImage.find_by_id_hash!(params[:id])

    if gend_image.user && gend_image.user == current_user
      gend_image.is_deleted = true
      gend_image.save!

      head :no_content
    else
      head :forbidden
    end

  end

end
