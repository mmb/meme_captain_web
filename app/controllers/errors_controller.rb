# Error report controller.
class ErrorsController < ApplicationController
  def index
    head(:forbidden) unless admin?

    @errored_src_images = SrcImage.without_image.where.not(error: nil).order(
      :updated_at).reverse_order
    @errored_gend_images = GendImage.without_image.where.not(error: nil).order(
      :updated_at).reverse_order
  end
end
