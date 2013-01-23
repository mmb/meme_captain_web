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
    @src_set = SrcSet.find_by_name(params[:id])

    if @src_set.user == current_user
      @src_set.add_src_images(params[:add_src_images]) if params[:add_src_images]
      @src_set.delete_src_images(params[:delete_src_images]) if params[:delete_src_images]

      if @src_set.update_attributes(params[:src_set])
        redirect_to @src_set
      else
        render :edit
      end
    else
      render :status => :forbidden, :text => 'Forbidden'
    end
  end

end