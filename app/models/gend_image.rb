# encoding: UTF-8

class GendImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern
  include HasPostProcessConcern

  belongs_to :src_image, counter_cache: true
  has_one :gend_thumb
  has_many :captions, order: :id
  belongs_to :user

  accepts_nested_attributes_for :captions, reject_if:
      proc { |attrs| attrs['text'].blank? }

  def format
    mime = Mime::Type.lookup(content_type)

    if mime.kind_of?(Mime::Type)
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

    thumb_img.resize_to_fit_anim!(MemeCaptainWeb::Config::ThumbSide)

    self.gend_thumb = GendThumb.new(image: thumb_img.to_blob)
  end

  scope :active, -> { where is_deleted: false }

  scope :owned_by, ->(user) { where user_id: user.try(:id) }

  scope :most_recent, lambda { |limit = 1|
    order(:updated_at).reverse_order.limit(limit)
  }

  scope :finished, -> { where work_in_progress: false }

  scope :publick, -> { where private: false }
end
