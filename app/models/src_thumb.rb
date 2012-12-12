class SrcThumb < ActiveRecord::Base
  attr_accessible :content_type, :height, :image, :size, :width

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :src_image

  before_validation :set_derived_image_fields

  def set_derived_image_fields
    if image
      img = Magick::Image.from_blob(image)[0]

      self.content_type = img.content_type
      self.height = img.rows
      self.size = image.size
      self.width = img.columns
    end
  end

end
