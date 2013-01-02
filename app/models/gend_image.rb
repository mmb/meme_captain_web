class GendImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern
  include HasPostProcessConcern

  attr_accessible :image, :src_image_id

  belongs_to :src_image
  has_one :gend_thumb
  has_many :captions

  protected

  def post_process
    self.image = MemeCaptain.meme_top_bottom(
        src_image.image,
        captions[0].text, captions[1].text,
        :font => captions[0].font).to_blob

    thumb_image = magick_image
    thumb_image.resize_to_fit!(
        MemeCaptainWeb::Config::ThumbSide,
        MemeCaptainWeb::Config::ThumbSide)

    self.gend_thumb = GendThumb.new(:image => thumb_image.to_blob)
  end

end
