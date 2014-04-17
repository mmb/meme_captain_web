# encoding: UTF-8

class GendImagesController < ApplicationController
  def new
    @gend_image = GendImage.new
    @gend_image.src_image = SrcImage.find_by_id_hash!(params[:src])
    @src_image_path = url_for(controller: :src_images, action: :show,
                              id: @gend_image.src_image.id_hash)

    @gend_image.captions.build(
        top_left_x_pct: 0.05,
        top_left_y_pct: 0,
        width_pct: 0.9,
        height_pct: 0.25)
    @gend_image.captions.build(
        top_left_x_pct: 0.05,
        top_left_y_pct: 0.75,
        width_pct: 0.9,
        height_pct: 0.25)
  end

  def index
    @gend_images = GendImage.without_image.includes(
        :gend_thumb).publick.active.most_recent.page(params[:page])
    @show_toolbar = false
  end

  def create
    src_image = SrcImage.find_by_id_hash!(params[:gend_image][:src_image_id])

    @gend_image = GendImage.new(gend_image_params)
    @gend_image.src_image = src_image
    @gend_image.user = current_user

    if @gend_image.save
      redirect_to controller: :gend_image_pages, action: :show,
                  id: @gend_image.id_hash
    else
      render :new
    end
  end

  def show
    gend_image = GendImage.find_by_id_hash_and_is_deleted!(params[:id], false)

    expires_in 1.day, public: true

    headers['Meme-Text'] = gend_image.captions.map do |c|
      Rack::Utils.escape(c.text)
    end.join('&')
    headers['Meme-Name'] = Rack::Utils.escape(
        gend_image.src_image.name) if gend_image.src_image.name
    headers['Meme-Source-Image'] = url_for(
        controller: :src_images, action: :show,
        id: gend_image.src_image.id_hash)

    if stale?(gend_image)
      render text: gend_image.image, content_type: gend_image.content_type
    end
  end

  def destroy
    gend_image = GendImage.find_by_id_hash!(params[:id])

    if gend_image.user && gend_image.user == current_user
      gend_image.is_deleted = true
      gend_image.save!

      head :no_content
    else
      head :forbidden
    end
  end

  private

  def gend_image_params
    params.require(:gend_image).permit({ captions_attributes: [
        :font, :text, :top_left_x_pct, :top_left_y_pct, :width_pct,
        :height_pct] }, :private, :email)
  end
end
