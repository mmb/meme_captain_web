class GendImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern
  include HasPostProcessConcern

  attr_accessible :image, :src_image_id, :captions_attributes

  belongs_to :src_image
  has_one :gend_thumb
  has_many :captions, :order => :id
  belongs_to :user

  accepts_nested_attributes_for :captions, reject_if: proc { |attrs| attrs['text'].blank? }

  protected

  def post_process
    self.image = MemeCaptain.meme(src_image.image, captions.map(&:text_pos)).to_blob

    thumb_img = magick_image_list

    thumb_img.resize_to_fit_anim!(MemeCaptainWeb::Config::ThumbSide)

    self.gend_thumb = GendThumb.new(:image => thumb_img.to_blob)
  end

  scope :active, where(:is_deleted => false)

  scope :owned_by, lambda { |user| where(:user_id => user.try(:id)) }

  scope :most_recent, lambda { |limit=1| order(:updated_at).reverse_order.limit(limit) }
end
