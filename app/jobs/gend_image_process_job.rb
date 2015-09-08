# Job to generate meme images and create thumbnails.
class GendImageProcessJob
  attr_reader :gend_image_id

  def initialize(gend_image_id)
    @gend_image_id = gend_image_id
  end

  def perform
    gend_image = GendImage.find(gend_image_id)

    meme = MemeCaptain.meme(
      gend_image.src_image.image,
      gend_image.captions.map(&:text_pos))

    gend_image.image = meme.to_blob

    meme.resize_to_fit_anim!(MemeCaptainWeb::Config::THUMB_SIDE)

    gend_image.create_gend_thumb(image: meme.to_blob)

    meme.destroy!

    gend_image.update!(work_in_progress: false)
  end

  def reschedule_at(current_time, _attempts)
    current_time + 1.second
  end

  def max_attempts
    1
  end

  def failure(job)
    return if job.last_error.blank?
    gend_image = GendImage.without_image.find(gend_image_id)
    error = job.last_error.split("\n").first
    gend_image.update_attribute(:error, error)
  end
end
