class SrcThumb < ActiveRecord::Base
  attr_accessible :format, :height, :image, :size, :width

  validates :format, :height, :image, :size, :width, presence: true

  belongs_to :src_image
end
