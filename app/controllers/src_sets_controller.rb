# encoding: UTF-8

class SrcSetsController < ApplicationController

  def new
    @src_set = SrcSet.new
  end

  def create
    @src_set = SrcSet.new(params[:src_set])
    @src_set.user = current_user

    if @src_set.save
      redirect_to(
          { action: :index },
          { notice: 'Source set created.' })
    else
      render :new
    end
  end

  def index
    @src_sets = SrcSet.active.not_empty.most_recent.page(params[:page])
  end

  def update
    unless current_user
      render status: :forbidden, text: 'Forbidden' && return
    end

    @src_set = SrcSet.where(
        name: params[:id], is_deleted: false).first_or_create do |ss|
      ss.user = current_user
    end

    if @src_set.user == current_user
      @src_set.add_src_images(
          params[:add_src_images]) if params[:add_src_images]
      @src_set.delete_src_images(
          params[:delete_src_images]) if params[:delete_src_images]

      respond_to do |format|
        if @src_set.update_attributes(params[:src_set])
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
    @src_set = SrcSet.find_by_name_and_is_deleted!(params[:id], false)
    @src_images = @src_set.src_images.without_image.active.most_used.page(
        params[:page])
  end

  def destroy
    @src_set = SrcSet.find_by_name_and_user_id_and_is_deleted!(
        params[:id], current_user.try(:id), false)

    @src_set.update_attribute(:is_deleted, true)
    redirect_to action: :index
  end

end
