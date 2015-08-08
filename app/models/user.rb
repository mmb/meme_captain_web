# encoding: UTF-8

# User model.
class User < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email

  has_secure_password

  has_many :src_images
  has_many :src_sets
  has_many :gend_images, through: :src_images

  def self.auth_case_insens(email, password)
    for_auth(email).find { |u| u.authenticate(password) }
  end

  def avatar
    Gravatar.new email
  end

  scope :for_auth, lambda { |email|
    where('LOWER(email) = ?'.freeze, email.downcase)
  }
end
