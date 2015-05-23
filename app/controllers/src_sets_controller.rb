# encoding: UTF-8

# Source image sets controller.
class SrcSetsController < ApplicationController
  def new
    @src_set = SrcSet.new
  end

  def create
    @src_set = SrcSet.new(src_set_params)
    @src_set.user = current_user

    if @src_set.save
      redirect_to(
        { action: :index },
        notice: 'Source set created.')
    else
      render :new
    end
  end

  def index
    @src_sets = SrcSet.active.not_empty.most_recent.page(params[:page])
  end

  def update
    # rubocop:disable Style/IfUnlessModifier
    unless current_user
      render status: :forbidden, text: 'Forbidden' && return
    end
    # rubocop:enable Style/IfUnlessModifier

    @src_set = SrcSet.active.where(
      name: params[:id]).first_or_create do |ss|
      ss.user = current_user
    end

    if @src_set.user == current_user
      add_src_images = params.delete(:add_src_images)
      @src_set.add_src_images(add_src_images) if add_src_images
      delete_src_images = params.delete(:delete_src_images)
      @src_set.delete_src_images(delete_src_images) if delete_src_images

      respond_to do |format|
        if @src_set.update_attributes(src_set_params)
          format.html do
            redirect_to(
              { action: :show, id: @src_set.name },
              notice: 'The set was successfully updated.')
          end
          format.json { render json: {} }
        else
          format.html { render :edit }
          format.json do
            render json: @src_set.errors, status: :unprocessable_entity
          end
        end
      end
    else
      render status: :forbidden, text: 'Forbidden'
    end
  end

  def show
    @src_set = SrcSet.active.find_by_name!(params[:id])
    @src_images = @src_set.src_images.without_image.active.most_used.page(
      params[:page])
  end

  def destroy
    @src_set = SrcSet.active.find_by_name_and_user_id!(
      params[:id], current_user.try(:id))

    @src_set.update_attribute(:is_deleted, true)
    redirect_to action: :index
  end

  private

  def src_set_params
    if params[:src_set] && !params[:src_set].empty?
      params.require(:src_set).permit(:name)
    else
      {}
    end
  end
end
