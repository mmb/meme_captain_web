class GendImage < ActiveRecord::Base
  attr_accessible :id_hash, :src_image, :user

  validates_presence_of :id_hash

  belongs_to :user
end
