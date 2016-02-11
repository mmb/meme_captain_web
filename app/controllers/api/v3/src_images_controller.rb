# encoding: UTF-8
# frozen_string_literal: true

module Api
  module V3
    # Source images controller.
    class SrcImagesController < ApplicationController
      include SrcImagesHelper

      def new
        return if not_logged_in 'Please login to create a source image.'.freeze

        @src_image = SrcImage.new
      end

      def index
        @src_images = SrcImage.for_user(current_user, params[:q], params[:page])
        respond_to do |format|
          format.html
          format.json { render_index_json }
        end
      end

      def create
        submitted_params = src_image_params
        read_image_data(submitted_params)

        @src_image = SrcImage.new(submitted_params)
        @src_image.user = current_user

        if @src_image.save
          create_success
        else
          create_fail
        end
      end

      def show
        src_image = SrcImage.active.finished.find_by!(id_hash: params[:id])

        expires_in 1.hour, public: true

        src_image_show_headers(src_image)

        return unless stale?(src_image)
        render text: src_image.image, content_type: src_image.content_type
      end

      def update
        @src_image = SrcImage.find_by!(id_hash: params[:id])

        if @src_image.user == current_user
          @src_image.update_attributes(src_image_edit_params)
        end

        respond_to { |format| format.json { respond_with_bip(@src_image) } }
      end

      def destroy
        src_image = SrcImage.find_by!(id_hash: params[:id])

        head(:forbidden) && return if src_image.user != current_user

        src_image.is_deleted = true
        src_image.save!

        head(:no_content)
      end

      private

      def src_image_params
        params.require(:src_image).permit(:image, :private, :url, :name)
      end

      def src_image_edit_params
        params.require(:src_image).permit(:name)
      end

      def read_image_data(submitted_params)
        if submitted_params.try(:[], :image)
          submitted_params[:image] = submitted_params[:image].read
          StatsD.increment('src_image.upload'.freeze)
        end
      end

      def create_success
        respond_to do |format|
          format.html do
            redirect_to(
              { controller: :my, action: :show },
              notice: 'Source image created.'.freeze
            )
          end
          format.json { redirect_to_pending }
        end
      end

      def create_fail
        respond_to do |format|
          format.html { render(:new) }
          format.json do
            render(json: @src_image.errors, status: :unprocessable_entity)
          end
        end
      end

      def render_index_json
        @src_images.each do |src_image|
          src_image.image_url = src_image_url_for(src_image)
        end
        render json: @src_images
      end

      def redirect_to_pending
        status_url = url_for(
          controller: :pending_src_images,
          action: :show,
          id: @src_image.id_hash)
        response.status = :accepted
        response.location = status_url
        render(json: {
                 id: @src_image.id_hash,
                 status_url: status_url
               })
      end

      def src_image_show_headers(src_image)
        headers['Content-Length'.freeze] = src_image.size
      end
    end
  end
end
