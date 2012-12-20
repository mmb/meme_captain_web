class GendImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern

  attr_accessible :image, :src_image_id

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :src_image
end
