class SrcSetsController < ApplicationController

  def new
    @src_set = SrcSet.new
  end

  def create
    @src_set = SrcSet.new(params[:src_set])
    @src_set.user = current_user

    if @src_set.save
      redirect_to(
          {:action => :index},
          {:notice => 'Source set created.'})
    else
      render :new
    end
  end

  def index
    @src_sets = SrcSet.owned_by(current_user).active.most_recent(8)
  end

  def update
    @src_set = SrcSet.find(params[:id])

    @src_set.src_images << SrcImage.find(params[:add_src_images]) if params[:add_src_images]

    @src_set.src_images.delete(SrcImage.find(params[:delete_src_images])) if params[:delete_src_images]

    if @src_set.update_attributes(params[:src_set])
      redirect_to @src_set
    else
      render :edit
    end

  end

end