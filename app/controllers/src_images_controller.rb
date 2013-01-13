class SrcImagesController < ApplicationController

  def new
    @src_image = SrcImage.new
  end

  def index
    @src_images = SrcImage.owned_by(current_user).active.most_recent(8)
  end

  def create
    @src_image = SrcImage.new(params[:src_image])
    @src_image.user = current_user

    if params[:src_image][:image]
      @src_image.image = params[:src_image][:image].read
    end

    if @src_image.save
      redirect_to({:action => :index}, {
          :notice => 'Source image created.'})
    else
      render :new
    end
  end

  def show
    src_image = SrcImage.find_by_id_hash!(params[:id])

    render :text => src_image.image, :content_type => src_image.content_type
  end

  def destroy
    src_image = SrcImage.find_by_id_hash!(params[:id])
    src_image.is_deleted = true
    src_image.save!

    redirect_to :action => :index
  end

end
