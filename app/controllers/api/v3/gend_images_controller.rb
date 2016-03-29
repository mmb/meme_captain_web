# encoding: UTF-8
# frozen_string_literal: true

module Api
  module V3
    # Generated (meme) images controller.
    class GendImagesController < ApplicationController
      wrap_parameters GendImage, include: [
        :captions_attributes,
        :private,
        :src_image_id
      ]

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
        src_image = SrcImage.without_image.active.finished.find_by!(
          id_hash: params[:gend_image][:src_image_id])

        gend_image = src_image.gend_images.build(gend_image_params)
        gend_image.assign_attributes(
          user: current_user,
          creator_ip: remote_ip)
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
            :height_pct] }, :private, :email)
      end

      def ok_response
        status_url = url_for(
          controller: :pending_gend_images,
          action: :show,
          id: @gend_image.id_hash)
        render(json: {
                 id: @gend_image.id_hash,
                 status_url: status_url
               })
      end
    end
  end
end
