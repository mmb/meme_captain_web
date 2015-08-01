# Job to generate meme images and create thumbnails.
class GendImageProcessJob < ActiveJob::Base
  queue_as :gend_image_process

  def perform(gend_image)
    meme = MemeCaptain.meme(
      gend_image.src_image.image,
      gend_image.captions.map(&:text_pos))

    gend_image.image = meme.to_blob

    meme.resize_to_fit_anim!(MemeCaptainWeb::Config::THUMB_SIDE)

    gend_image.gend_thumb = GendThumb.new(image: meme.to_blob)

    meme.destroy!

    gend_image.work_in_progress = false

    gend_image.save!
  end
end
