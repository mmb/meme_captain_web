class SrcImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern
  include HasPostProcessConcern

  attr_accessible :image, :url

  validates :content_type, :height, :image, :size, :width, presence: true

  belongs_to :user
  has_one :src_thumb
  has_many :gend_images
  has_and_belongs_to_many :src_sets

  protected

  def post_process
    img = magick_image

    # Resize large images.
    if width > MemeCaptainWeb::Config::SourceImageSide or
        height > MemeCaptainWeb::Config::SourceImageSide
      img.resize_to_fit!(MemeCaptainWeb::Config::SourceImageSide)
      self.image = img.to_blob
    end

    # Generate thumbnail.
    img.resize_to_fill!(
        MemeCaptainWeb::Config::ThumbSide,
        MemeCaptainWeb::Config::ThumbSide)

    self.src_thumb = SrcThumb.new(:image => img.to_blob)
  end

end
