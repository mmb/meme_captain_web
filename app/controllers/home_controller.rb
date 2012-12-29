class HomeController < ApplicationController

  def index
    if current_user
      @src_images = current_user.src_images.sort {
          |a, b| b.updated_at <=> a.updated_at }

      @gend_images = current_user.gend_images.sort {
          |a, b| b.updated_at <=> a.updated_at }
    else
      @src_images = []
      @gend_images = []
    end

  end

end