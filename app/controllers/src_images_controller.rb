class SrcImagesController < ApplicationController

  def new
    @src_image = SrcImage.new
  end

  def index
    return if not_logged_in 'Please login to view source images.'

    @src_images = SrcImage.without_image.includes(:src_thumb).owned_by(current_user).active.most_recent.page(params[:page])
  end

  def create
    @src_image = SrcImage.new(params[:src_image])
    @src_image.user = current_user

    if params.try(:[], :src_image).try(:[], :image)
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

    if src_image.user == current_user
      src_image.is_deleted = true
      src_image.save!

      head :no_content
    else
      head :forbidden
    end

  end

end
