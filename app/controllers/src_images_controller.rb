# encoding: UTF-8

# Source images controller.
class SrcImagesController < ApplicationController
  def new
    return if not_logged_in 'Please login to create a source image.'

    @src_image = SrcImage.new
  end

  def index
    query = params[:q].try(:strip)
    @src_images = SrcImage.without_image.includes(:src_thumb).name_matches(
      query).publick.active.finished.most_used.page(params[:page])
  end

  def create
    submitted_params = src_image_params
    read_image_data(submitted_params)

    @src_image = SrcImage.new(submitted_params)
    @src_image.user = current_user

    respond_to do |format|
      if @src_image.save
        create_success(format)
      else
        create_fail(format)
      end
    end
  end

  def show
    src_image = SrcImage.finished.find_by!(id_hash: params[:id])

    expires_in 1.hour, public: true

    return unless stale?(src_image)
    render text: src_image.image, content_type: src_image.content_type
  end

  def update
    @src_image = SrcImage.find_by!(id_hash: params[:id])

    if @src_image.user == current_user
      @src_image.update_attributes(src_image_edit_params)
    end

    respond_to { |format| format.json { respond_with_bip(@src_image) } }
  end

  def destroy
    src_image = SrcImage.find_by!(id_hash: params[:id])

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

  def src_image_edit_params
    params.require(:src_image).permit(:name)
  end

  def read_image_data(submitted_params)
    # rubocop:disable Style/GuardClause
    if submitted_params.try(:[], :image)
      submitted_params[:image] = submitted_params[:image].read
    end
    # rubocop:enable Style/GuardClause
  end

  def create_success(format)
    format.html do
      redirect_to(
        { controller: :my, action: :show },
        notice: 'Source image created.'
      )
    end
    format.json { render json: { id: @src_image.id_hash } }
  end

  def create_fail(format)
    format.html { render :new }
    format.json do
      render json: @src_image.errors, status: :unprocessable_entity
    end
  end
end
