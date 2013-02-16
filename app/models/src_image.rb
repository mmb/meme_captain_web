require 'net/http'

class SrcImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern
  include HasPostProcessConcern

  attr_accessible :image, :url

  belongs_to :user
  has_one :src_thumb
  has_many :gend_images
  has_and_belongs_to_many :src_sets

  validate :image_if_not_url

  def image_if_not_url
    if url.blank? && image.blank?
      errors.add :image, 'is required if url is not set.'
    end
  end

  protected

  def load_from_url
    uri = URI(url)
    self.image = Net::HTTP.get(uri)
    set_derived_image_fields
  end

  def post_process
    load_from_url if url

    img = magick_image_list

    img.auto_orient!
    img.strip!

    if width > MemeCaptainWeb::Config::SourceImageSide or
        height > MemeCaptainWeb::Config::SourceImageSide
      img.resize_to_fit_anim!(MemeCaptainWeb::Config::SourceImageSide)
    end

    thumb_img = img.resize_to_fill_anim(MemeCaptainWeb::Config::ThumbSide)

    watermark_img = Magick::ImageList.new(Rails.root + 'app/assets/images/watermark.png')
    img.extend MemeCaptain::ImageList::Watermark
    img.watermark_mc watermark_img

    self.image = img.to_blob

    self.src_thumb = SrcThumb.new(:image => thumb_img.to_blob)
  end

  scope :active, where(:is_deleted => false)

  scope :owned_by, lambda { |user| where(:user_id => user.id) }

  scope :most_recent, lambda { |limit=1| order(:updated_at).reverse_order.limit(limit) }
end
