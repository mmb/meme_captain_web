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
    img = magick_image_list

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

end
