# Job to generate meme images and create thumbnails.
class GendImageProcessJob < ActiveJob::Base
  queue_as do
    gend_image = GendImage.without_image.find(arguments.first)
    src_image = SrcImage.without_image.find(gend_image.src_image_id)

    case src_image.size
    when 0.kilobytes...100.kilobytes
      :gend_image_process_small
    when 100.kilobytes...1.megabyte
      :gend_image_process_medium
    when 1.megabyte...10.megabytes
      :gend_image_process_large
    else
      :gend_image_process_shitload
    end
  end

  def perform(gend_image_id)
    gend_image = GendImage.find(gend_image_id)

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
