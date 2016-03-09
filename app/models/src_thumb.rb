# encoding: UTF-8

# Source image thumbnail model.
class SrcThumb < ActiveRecord::Base
  include HasImageConcern

  before_validation :set_derived_image_fields
  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :src_image

  default_scope { without_image }
end
