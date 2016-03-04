# Gend image API script controller.
class GendImageScriptsController < ApplicationController
  def show
    gend_image = GendImage.active.finished.find_by!(id_hash: params[:id])

    @endpoint = api_v3_gend_images_url

    @json = MemeCaptainWeb::GendImageApiRequestJson.new(gend_image).json
  end
end
