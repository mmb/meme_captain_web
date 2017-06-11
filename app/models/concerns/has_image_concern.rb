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

  def image_external_body(client = nil)
    return unless image_external_bucket && image_external_key
    client ||= Aws::S3::Client.new
    client.get_object(
      bucket: image_external_bucket,
      key: image_external_key
    ).body
  end

  def set_image_hash
    return unless image
    update!(image_hash: Digest::SHA2.new.hexdigest(image))
  end

  def move_image_external(bucket, client = nil)
    client ||= Aws::S3::Client.new
    key = write_image_external(bucket, client)
    update!(
      image_external_bucket: bucket,
      image_external_key: key,
      image: nil
    )
  end

  private

  def load_image_dimension_fields(img)
    self.width = img.columns
    self.height = img.rows
    self.size = image.size
  end

  def write_image_external(bucket, client)
    return image_hash if image_external_exists(bucket, image_hash, client)

    client.put_object(
      bucket: bucket,
      key: image_hash,
      body: image
    )

    image_hash
  end

  def image_external_exists(bucket, key, client)
    client.head_object(bucket: bucket, key: key)
    true
  rescue Aws::S3::Errors::Forbidden
    false
  end
end
