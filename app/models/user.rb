class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_uniqueness_of :email

  has_secure_password

  has_many :src_images
  has_many :gend_images, :through => :src_images
end
