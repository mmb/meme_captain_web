# encoding: UTF-8
# frozen_string_literal: true

require 'digest/sha2'

# ActiveRecord::Model mixin for models that store an image in a binary
# column.
module HasImageConcern
  extend ActiveSupport::Concern

  included do
    scope :without_image, lambda {
      select((column_names - ['image'.freeze]).map { |c| "#{table_name}.#{c}" })
    }
  end

  def set_derived_image_fields
    return unless image
    img = magick_image_list

    self.content_type = img.content_type
    load_image_dimension_fields(img)
    self.is_animated = img.animated? if respond_to?(:is_animated=)
    img.destroy!
    true # must return true for before_validation callback
  end

  def format
    mime = Mime::Type.lookup(content_type)

    return unless mime.is_a?(Mime::Type)

    { jpeg: :jpg }.fetch(mime.symbol, mime.symbol)
  end

  def magick_image_list
    img_blob_loader = MemeCaptainWeb::ImgBlobLoader.new
    img_blob_loader.load_blob(image)
  end

  def dimensions
    "#{width}x#{height}"
  end

  def set_image_hash
    return unless image
    update!(image_hash: Digest::SHA2.new.hexdigest(image))
  end

  private

  def load_image_dimension_fields(img)
    self.width = img.columns
    self.height = img.rows
    self.size = image.size
  end
end
