# encoding: UTF-8
# frozen_string_literal: true

module Api
  module V3
    # Generated (meme) images controller.
    class GendImagesController < ApplicationController
      include GendImagesHelper

      wrap_parameters GendImage, include: [
        :captions_attributes,
        :private,
        :src_image_id
      ]

      def index
        gend_images = GendImage.for_user(
          current_user, params[:q], params[:page]
        ).includes(:captions)

        gend_images.each { |gend_image| url_fields(gend_image) }

        respond_to do |format|
          format.json do
            render(json: gend_images)
          end
        end
      end

      def create
        @gend_image = build_gend_image_for_create

        if @gend_image.save
          create_success
        else
          create_fail
        end
      end

      private

      def build_gend_image_for_create
        src_image_id = params.fetch(:gend_image, {})[:src_image_id]
        src_image = SrcImage.without_image.active.finished.find_by!(
          id_hash: src_image_id
        )

        gend_image = src_image.gend_images.build(gend_image_params)
        gend_image.assign_attributes(
          user: current_user,
          creator_ip: remote_ip
        )
        gend_image
      end

      def create_success
        respond_to do |format|
          format.json { ok_response }
        end
      end

      def create_fail
        respond_to do |format|
          format.json do
            render(json: @gend_image.errors, status: :unprocessable_entity)
          end
        end
      end

      def gend_image_params
        params.require(:gend_image).permit(
          { captions_attributes: [
            :font, :text, :top_left_x_pct, :top_left_y_pct, :width_pct,
            :height_pct
          ] }, :private, :email
        )
      end

      def ok_response
        status_url = url_for(
          controller: :pending_gend_images,
          action: :show,
          id: @gend_image.id_hash
        )
        render(json: {
                 id: @gend_image.id_hash,
                 status_url: status_url
               })
      end

      def url_fields(gend_image)
        gend_image.image_url = gend_image_url_for(gend_image)
        gend_image.thumbnail_url = gend_thumb_url_for(gend_image)
      end
    end
  end
end
