# Job to generate meme images and create thumbnails.
class GendImageProcessJob < ActiveJob::Base
  queue_as :gend_image_process

  def perform(gend_image)
    gend_image.image = MemeCaptain.meme(
      gend_image.src_image.image,
      gend_image.captions.map(&:text_pos)).to_blob

    thumb_img = gend_image.magick_image_list

    thumb_img.resize_to_fit_anim!(MemeCaptainWeb::Config::THUMB_SIDE)

    gend_image.gend_thumb = GendThumb.new(image: thumb_img.to_blob)

    thumb_img.destroy!

    gend_image.work_in_progress = false

    gend_image.save!
  end
end
