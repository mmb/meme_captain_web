class SrcImage < ActiveRecord::Base
  attr_accessible :format, :height, :id_hash, :image, :size, :url, :width

  validates :format, :height, :id_hash, :image, :size, :width, presence: true

  validates :id_hash, uniqueness: true

  belongs_to :user
  has_one :src_thumb
end
