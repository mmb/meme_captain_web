# encoding: UTF-8

# Generated (meme) images controller.
class GendImagesController < ApplicationController
  def new
    src_image = SrcImage.without_image.find_by!(id_hash: params[:src])
    @src_image_path = url_for(
      controller: :src_images, action: :show, id: src_image.id_hash)

    @gend_image = GendImage.new(
      src_image: src_image,
      private: src_image.private)
    build_captions
  end

  def index
    @gend_images = GendImage.without_image.includes(
      :gend_thumb).publick.active.most_recent.page(params[:page])
    @show_toolbar = false
  end

  def create
    src_image = SrcImage.find_by!(
      id_hash: params[:gend_image][:src_image_id])

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
    gend_image = GendImage.active.find_by!(id_hash: params[:id])
    src_image = SrcImage.without_image.find(gend_image.src_image_id)

    expires_in 1.day, public: true

    headers['Meme-Text'] = gend_image.captions.map do |c|
      Rack::Utils.escape(c.text)
    end.join('&')
    headers['Meme-Name'] = Rack::Utils.escape(
      src_image.name) if src_image.name
    headers['Meme-Source-Image'] = url_for(
      controller: :src_images, action: :show,
      id: src_image.id_hash)

    return unless stale?(gend_image)
    render text: gend_image.image, content_type: gend_image.content_type
  end

  def destroy
    gend_image = GendImage.find_by!(id_hash: params[:id])

    if gend_image.user && gend_image.user == current_user
      gend_image.is_deleted = true
      gend_image.save!

      head :no_content
    else
      head :forbidden
    end
  end

  private

  def build_captions
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

  def gend_image_params
    params.require(:gend_image).permit({ captions_attributes: [
      :font, :text, :top_left_x_pct, :top_left_y_pct, :width_pct,
      :height_pct] }, :private, :email)
  end
end
