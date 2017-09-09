# frozen_string_literal: true

# Source image thumbnail model.
class SrcThumb < ApplicationRecord
  include HasImageConcern

  before_validation :set_derived_image_fields
  validates :content_type, :height, :size, :width, presence: true

  belongs_to :src_image, optional: true

  default_scope { without_image }
end
