class GendImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern

  attr_accessible :image, :src_image_id

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :src_image
  has_one :gend_thumb

  after_commit :create_thumbnail_job

  protected

  def create_thumbnail_job
    self.delay.create_thumbnail  unless gend_thumb
  end

  def create_thumbnail
    thumb_image = Magick::Image.from_blob(image)[0]
    thumb_image.resize_to_fill!(
      MemeCaptainWeb::Config::ThumbSide,
      MemeCaptainWeb::Config::ThumbSide)

    self.gend_thumb = GendThumb.new(:image => thumb_image.to_blob)
  end

end
