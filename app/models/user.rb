class User < ActiveRecord::Base
  attr_accessible :email

  validates_presence_of :email
  validates_uniqueness_of :email

  validates_presence_of :password_digest
end
