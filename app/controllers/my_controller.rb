# encoding: UTF-8

# User page controller.
class MyController < ApplicationController
  def show
    return if not_logged_in

    @src_sets = src_sets
    @src_images = src_images
    @gend_images = gend_images
    @show_toolbar = true
    @api_token = api_token
  end

  private

  def src_sets
    SrcSet.owned_by(current_user).active.most_recent.page(params[:page])
  end

  def src_images
    SrcImage.without_image.includes(:src_thumb).owned_by(
      current_user).active.most_recent.page(params[:page])
  end

  def gend_images
    GendImage.without_image.includes(:gend_thumb).owned_by(
      current_user).active.most_recent.page(params[:page])
  end

  def api_token
    current_user.try(:api_token)
  end
end
