# frozen_string_literal: true

# Generated (meme) image thumbnail model.
class GendThumb < ApplicationRecord
  include HasImageConcern

  before_validation :set_derived_image_fields
  validates :content_type, :height, :size, :width, presence: true

  belongs_to :gend_image

  default_scope { without_image }
end
