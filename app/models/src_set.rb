class SrcSet < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true
  validates :name, uniqueness: true

  has_and_belongs_to_many :src_images
  belongs_to :user
end
