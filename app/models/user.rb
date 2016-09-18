# encoding: UTF-8
# frozen_string_literal: true

require 'digest/md5'

# User model.
class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true

  has_secure_password

  has_many :src_images
  has_many :src_sets
  has_many :gend_images, through: :src_images

  def self.auth_case_insens(email, password)
    for_auth(email).find { |u| u.authenticate(password) }
  end

  def avatar_url(size)
    hash = Digest::MD5.hexdigest(email.strip.downcase)
    "https://secure.gravatar.com/avatar/#{hash}?s=#{size.to_i}"
  end

  scope :for_auth, lambda { |email|
    where('LOWER(email) = ?'.freeze, email.downcase)
  }
end
