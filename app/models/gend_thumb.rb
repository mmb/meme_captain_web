class GendThumb < ActiveRecord::Base
  include HasImageConcern

  attr_accessible :content_type, :height, :image, :size, :width

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :gend_image
end
