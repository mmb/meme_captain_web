# ActiveRecord::Model mixin for models that store an image in a binary
# column.
module HasImageConcern
  extend ActiveSupport::Concern

  included do
    before_validation :set_derived_image_fields

    scope :without_image, :select => (column_names - ['image']).map { |c| "#{table_name}.#{c}" }
  end

  def set_derived_image_fields
    if image
      img = magick_image_list

      self.content_type = img.content_type
      self.height = img.rows
      self.size = image.size
      self.width = img.columns
    end
  end

  def magick_image_list
    Magick::ImageList.new.from_blob(image)
  end

end
