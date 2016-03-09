# encoding: UTF-8
# frozen_string_literal: true

# Generated (meme) images controller.
class GendImagesController < ApplicationController
  include SrcImagesHelper

  wrap_parameters GendImage, include: [
    :captions_attributes,
    :private,
    :src_image_id
  ]

  def new
    src_image = SrcImage.without_image.active.find_by!(id_hash: params[:src])
    @src_image_path = url_for(
      controller: :src_images, action: :show, id: src_image.id_hash)
    @src_image_url_with_extension = src_image_url_for(src_image)

    @gend_image = GendImage.new(
      src_image: src_image,
      private: src_image.private)
    MemeCaptainWeb::CaptionBuilder.new.build(@gend_image)
  end

  def index
    @gend_images = GendImage.for_user(current_user, nil, params[:page])
  end

  def create
    @gend_image = build_gend_image_for_create
    check_bot_attempt

    if @gend_image.save
      create_success
    else
      create_fail
    end
  end

  def show
    gend_image = GendImage.active.finished.find_by!(id_hash: params[:id])

    expires_in 1.day, public: true

    gend_image_show_headers(gend_image)

    return unless stale?(gend_image)
    headers['Content-Type'.freeze] = gend_image.content_type
    render(text: gend_image.image)
  end

  def destroy
    gend_image = GendImage.find_by!(id_hash: params[:id])

    if gend_image.user && gend_image.user == current_user
      gend_image.update!(is_deleted: true)

      head :no_content
    else
      head :forbidden
    end
  end

  private

  def build_gend_image_for_create
    src_image = SrcImage.without_image.active.finished.find_by!(
      id_hash: params[:gend_image][:src_image_id])

    gend_image = src_image.gend_images.build(gend_image_params)
    gend_image.assign_attributes(
      user: current_user,
      creator_ip: remote_ip)
    gend_image
  end

  def check_bot_attempt
    return if params[:gend_image][:email].blank?
    StatsD.increment('bot.attempt'.freeze)
  end

  def create_success
    respond_to do |format|
      format.html { redirect_to_page }
      format.json { redirect_to_pending }
    end
  end

  def create_fail
    respond_to do |format|
      format.html { render :new }
      format.json do
        render(json: @gend_image.errors, status: :unprocessable_entity)
      end
    end
  end

  def gend_image_params
    params.require(:gend_image).permit(
      { captions_attributes: [
        :font, :text, :top_left_x_pct, :top_left_y_pct, :width_pct,
        :height_pct] }, :private, :email)
  end

  def redirect_to_pending
    status_url = url_for(
      controller: :pending_gend_images,
      action: :show,
      id: @gend_image.id_hash)
    response.status = :accepted
    response.location = status_url
    render(json: { status_url: status_url })
  end

  def redirect_to_page
    redirect_to(
      controller: :gend_image_pages, action: :show, id: @gend_image.id_hash)
  end

  def gend_image_show_headers(gend_image)
    src_image = SrcImage.without_image.find(gend_image.src_image_id)

    headers.merge!(
      'Content-Length'.freeze => gend_image.size,
      'Meme-Name'.freeze => Rack::Utils.escape(src_image.name),
      'Meme-Source-Image'.freeze => src_image_url_for(src_image),
      'Meme-Text'.freeze => gend_image.meme_text_header)
  end
end
