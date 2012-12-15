class SrcImage < ActiveRecord::Base
  include IdHashConcern

  attr_accessible :image, :url

  validates :content_type, :height, :image, :size, :width, presence: true

  validates :id_hash, uniqueness: true

  belongs_to :user
  has_one :src_thumb

  before_validation :set_derived_image_fields

  after_commit :create_thumbnail_job

  protected

  def set_derived_image_fields
    if image
      img = Magick::Image.from_blob(image)[0]

      self.content_type = img.content_type
      self.height = img.rows
      self.size = image.size
      self.width = img.columns
    end
  end

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
