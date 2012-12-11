class SrcImagesController < ApplicationController

  def new
    @src_image = SrcImage.new
  end

  def index
    @src_images = current_user.src_images
  end

  def create
    @src_image = SrcImage.new(params[:src_image])
    @src_image.user = current_user

    if params[:src_image][:image]
      @src_image.image = params[:src_image][:image].read
    end

    if @src_image.save
      redirect_to({ :action => :index }, {
        :notice => 'Source image created.' })
    else
      render :new
    end
  end

  def show
    src_image = SrcImage.find(params[:id])

    render :text => src_image.image, :content_type => src_image.content_type
  end

end
