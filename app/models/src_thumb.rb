# Source image thumbnail model.
class SrcThumb < ApplicationRecord
  include HasImageConcern

  before_validation :set_derived_image_fields
  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :src_image, optional: true

  default_scope { without_image }
end
