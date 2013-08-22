class GendThumb < ActiveRecord::Base
  include HasImageConcern

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :gend_image

  default_scope { without_image }
end
