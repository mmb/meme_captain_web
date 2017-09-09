# frozen_string_literal: true

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
        notice: 'Source set created.'
      )
    else
      render :new
    end
  end

  def index
    @src_sets = SrcSet.active.not_empty.most_recent.page(params[:page])
  end

  def update
    render(status: :forbidden, plain: 'Forbidden') && return unless current_user

    @src_set = first_or_create

    unless @src_set.user == current_user
      render(status: :forbidden, plain: 'Forbidden') && return
    end

    add_and_delete

    update_src_set
  end

  def show
    @src_set = SrcSet.active.find_by!(name: params[:id])
    @src_images = @src_set.src_images.without_image.active.most_used.page(
      params[:page]
    )
  end

  def destroy
    @src_set = SrcSet.active.find_by!(
      name: params[:id], user_id: current_user.try(:id)
    )

    @src_set.update_attribute(:is_deleted, true)
    redirect_to action: :index
  end

  private

  def src_set_params
    if params[:src_set].present?
      params.require(:src_set).permit(:name)
    else
      {}
    end
  end

  def first_or_create
    SrcSet.active.where(
      name: params[:id]
    ).first_or_create do |ss|
      ss.user = current_user
    end
  end

  def add_and_delete
    add_src_images = params.delete(:add_src_images)
    @src_set.add_src_images(add_src_images) if add_src_images

    delete_src_images = params.delete(:delete_src_images)
    @src_set.delete_src_images(delete_src_images) if delete_src_images
  end

  def update_src_set
    if @src_set.update_attributes(src_set_params)
      update_success
    else
      update_fail
    end
  end

  def update_success
    respond_to do |format|
      format.html do
        redirect_to(
          { action: :show, id: @src_set.name },
          notice: 'The set was successfully updated.'
        )
      end
      format.json { render(json: {}) }
    end
  end

  def update_fail
    respond_to do |format|
      format.html { render(:edit) }
      format.json do
        render(json: @src_set.errors, status: :unprocessable_entity)
      end
    end
  end
end
