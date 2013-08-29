# encoding: UTF-8

class SrcImagesController < ApplicationController

  def new
    return if not_logged_in 'Please login to create a source image.'

    @src_image = SrcImage.new
  end

  def index
    @src_images = SrcImage.without_image.includes(:src_thumb).name_matches(
        params[:q]).publick.active.finished.most_used.page(params[:page])
  end

  def create
    return if not_logged_in 'Please login to create source images.'

    @src_image = SrcImage.new(src_image_params)
    @src_image.user = current_user

    if params.try(:[], :src_image).try(:[], :image)
      @src_image.image = params[:src_image][:image].read
    end

    respond_to do |format|
      if @src_image.save
        format.html do
          redirect_to({ controller: :my, action: :show }, {
              notice: 'Source image created.' })
        end
        format.json { render json: {} }
      else
        format.html { render :new }
        format.json do
          render json: @src_image.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def show
    src_image = SrcImage.find_by_id_hash!(params[:id])

    expires_in 1.hour, public: true

    if stale?(src_image)
      render text: src_image.image, content_type: src_image.content_type
    end
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

  private

  def src_image_params
    params.require(:src_image).permit(:image, :private, :url, :name)
  end
end
