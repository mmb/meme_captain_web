# encoding: UTF-8

# Generated (meme) image model.
class GendImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern

  belongs_to :src_image, counter_cache: true
  has_one :gend_thumb
  has_many :captions, -> { order :id }
  belongs_to :user

  accepts_nested_attributes_for :captions, reject_if:
      proc { |attrs| attrs['text'.freeze].blank? }

  # This email field is a negative captcha. If form bots fill it in,
  # validation will fail.
  attr_accessor :email

  before_validation :set_derived_image_fields
  validates :email, length: { maximum: 0 }

  after_commit :create_jobs, on: :create

  def create_jobs
    GendImageProcessJob.perform_later(id)
  end

  def meme_text_header
    Rails.cache.fetch("#{cache_key}/meme_text_header") do
      captions.map { |c| Rack::Utils.escape(c.text) }.join('&'.freeze)
    end
  end

  protected

  scope :active, -> { where is_deleted: false }

  scope :owned_by, ->(user) { where user_id: user.try(:id) }

  scope :most_recent, lambda { |limit = 1|
    order(:updated_at).reverse_order.limit(limit)
  }

  scope :finished, -> { where work_in_progress: false }

  scope :publick, -> { where private: false }

  scope :caption_matches, lambda { |query|
    joins(:captions).where(
      'LOWER(captions.text) LIKE ?'.freeze, "%#{query.downcase}%").uniq if query
  }
end
