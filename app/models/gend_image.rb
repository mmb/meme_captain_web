# frozen_string_literal: true

# Generated (meme) image model.
class GendImage < ApplicationRecord
  include HasImageConcern
  include IdHashConcern
  include SearchDocumentConcern

  belongs_to :src_image, counter_cache: true
  has_one :gend_thumb
  has_many :captions, -> { order :id }
  belongs_to :user

  accepts_nested_attributes_for :captions, reject_if:
      proc { |attrs| attrs['text'.freeze].blank? }

  # This email field is a negative captcha. If form bots fill it in,
  # validation will fail.
  attr_accessor :email

  attr_accessor :image_url
  attr_accessor :thumbnail_url

  before_validation :set_derived_image_fields
  validates :email, length: { maximum: 0 }

  after_commit :create_jobs, on: :create

  def create_jobs
    GendImageProcessJob.new(id).delay(queue: queue).perform
  end

  def meme_text
    captions.position_order.map(&:text).join(' '.freeze)
  end

  def headers
    {
      'Content-Length'.freeze => size,
      'Content-Type'.freeze => content_type
    }
  end

  def self.for_user(user, query, page)
    if user.try(:is_admin)
      without_image.includes(:gend_thumb).text_matches(query)
                   .most_recent.page(page)
    else
      without_image.includes(:gend_thumb).text_matches(query)
                   .publick.active.finished.most_recent.page(page)
    end
  end

  scope :active, -> { where is_deleted: false }

  scope :owned_by, ->(user) { where user_id: user.try(:id) }

  scope :most_recent, lambda { |limit = 1|
    order(:updated_at).reverse_order.limit(limit)
  }

  scope :finished, -> { where work_in_progress: false }

  scope :publick, -> { where private: false }

  scope :text_matches, MemeCaptainWeb::TextMatchLambda.new.lambder(
    self, :search_document
  )

  def self.searchable_columns
    [:search_document]
  end

  private

  def queue
    case src_image.size
    when 0.kilobytes...100.kilobytes
      :gend_image_process_small
    when 100.kilobytes...1.megabyte
      :gend_image_process_medium
    when 1.megabyte...10.megabytes
      :gend_image_process_large
    else
      :gend_image_process_shitload
    end
  end

  def search_document_parts
    # can't use Caption.position_order because the records are not saved yet
    parts = captions.sort_by do |c|
      [c.top_left_y_pct, c.top_left_x_pct]
    end.map(&:text)
    parts << src_image.name
    parts << id_hash
  end
end
