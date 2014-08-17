# encoding: UTF-8

# Generated (meme) image model.
class GendImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern
  include HasPostProcessConcern

  belongs_to :src_image, counter_cache: true
  has_one :gend_thumb
  has_many :captions, -> { order :id }
  belongs_to :user

  accepts_nested_attributes_for :captions, reject_if:
      proc { |attrs| attrs['text'].blank? }

  # This email field is a negative captcha. If form bots fill it in,
  # validation will fail.
  attr_accessor :email
  validates :email, length: { maximum: 0 }

  def format
    mime = Mime::Type.lookup(content_type)

    if mime.is_a?(Mime::Type)
      {
        jpeg: :jpg
      }.fetch(mime.symbol, mime.symbol)
    else
      nil
    end
  end

  protected

  def post_process
    self.image = MemeCaptain.meme(
        src_image.image, captions.map(&:text_pos)).to_blob

    thumb_img = magick_image_list

    thumb_img.resize_to_fit_anim!(MemeCaptainWeb::Config::THUMB_SIDE)

    self.gend_thumb = GendThumb.new(image: thumb_img.to_blob)
  end

  scope :active, -> { where is_deleted: false }

  scope :owned_by, ->(user) { where user_id: user.try(:id) }

  scope :most_recent, lambda { |limit = 1|
    order(:updated_at).reverse_order.limit(limit)
  }

  scope :finished, -> { where work_in_progress: false }

  scope :publick, -> { where private: false }

  scope :caption_matches, lambda { |query|
    joins(:captions).where(
        'LOWER(captions.text) LIKE ?', "%#{query.downcase}%") if query
  }
end
