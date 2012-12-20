class SrcImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern

  attr_accessible :image, :url

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :user
  has_one :src_thumb
  has_many :gend_images

  after_commit :create_thumbnail_job

  protected

  def create_thumbnail_job
    self.delay.create_thumbnail  unless src_thumb
  end

  def create_thumbnail
    thumb_image = Magick::Image.from_blob(image)[0]
    thumb_image.resize_to_fill!(
      MemeCaptainWeb::Config::ThumbSide,
      MemeCaptainWeb::Config::ThumbSide)

    self.src_thumb = SrcThumb.new(:image => thumb_image.to_blob)
  end

end
