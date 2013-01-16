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

end
