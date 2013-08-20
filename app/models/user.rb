class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_uniqueness_of :email

  has_secure_password

  has_many :src_images
  has_many :src_sets
  has_many :gend_images, :through => :src_images

  def owns?(o)
    o.user == self
  end

  def self.auth_case_insens(email, password)
    for_auth(email).find { |u| u.authenticate(password) }
  end

  def avatar
    Gravatar.new email
  end

  scope :for_auth, ->(email) { where('LOWER(email) = ?', email.downcase) }

end
