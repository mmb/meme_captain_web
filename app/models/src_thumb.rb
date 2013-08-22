class SrcThumb < ActiveRecord::Base
  include HasImageConcern

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :src_image

end
