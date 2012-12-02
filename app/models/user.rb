class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_uniqueness_of :email

  has_secure_password
end
