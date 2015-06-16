# encoding: UTF-8

# ActiveRecord::Model mixin for models that store an image in a binary
# column.
module HasImageConcern
  extend ActiveSupport::Concern

  included do
    scope :without_image, lambda {
      select((column_names - ['image']).map { |c| "#{table_name}.#{c}" })
    }
  end

  def set_derived_image_fields
    return unless image
    img = magick_image_list

    self.content_type = img.content_type
    self.height = img.rows
    self.size = image.size
    self.width = img.columns
    self.is_animated = img.animated? if self.respond_to?(:is_animated=)
    img.destroy!
    true # must return true for before_validation callback
  end

  def format
    mime = Mime::Type.lookup(content_type)

    return unless mime.is_a?(Mime::Type)

    { jpeg: :jpg }.fetch(mime.symbol, mime.symbol)
  end

  def magick_image_list
    Magick::ImageList.new.from_blob(image)
  end
end
