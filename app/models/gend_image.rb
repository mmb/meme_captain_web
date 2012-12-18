class GendImage < ActiveRecord::Base
  attr_accessible :id_hash, :src_image

  validates_presence_of :id_hash

  belongs_to :src_image
end
