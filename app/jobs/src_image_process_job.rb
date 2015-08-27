# Job to fetch and normalize source images and create thumbnails.
class SrcImageProcessJob
  attr_reader :src_image_id

  def initialize(src_image_id)
    @src_image_id = src_image_id
  end

  def perform
    src_image = SrcImage.find(src_image_id)
    src_image.load_from_url

    check_image_size(src_image)

    img = src_image.magick_image_list

    MemeCaptainWeb::ImageFormatConverter.new.convert(img)

    img.auto_orient!
    img.strip!

    MemeCaptainWeb::ImgSizeConstrainer.new.constrain_size(img)

    thumb_img = img.resize_to_fill_anim(MemeCaptainWeb::Config::THUMB_SIDE)

    watermark(img)

    src_image.attributes = {
      image: img.to_blob,
      src_thumb: SrcThumb.new(image: thumb_img.to_blob),
      work_in_progress: false
    }

    thumb_img.destroy!
    img.destroy!

    src_image.set_derived_image_fields

    src_image.save!

    SrcImageNameJob.new(src_image.id).delay(queue: :src_image_name).perform
  end

  def reschedule_at(current_time, _attempts)
    current_time + 1.second
  end

  def max_attempts
    3
  end

  def failure(job)
    return if job.last_error.blank?
    src_image = SrcImage.without_image.find(src_image_id)
    error = job.last_error.split("\n").first
    src_image.update_attribute(:error, error)
  end

  private

  def watermark(img)
    watermark_img = Magick::ImageList.new(
      Rails.root + 'app/assets/images/watermark.png'.freeze)
    img.extend(MemeCaptain::ImageList::Watermark)
    img.watermark_mc(watermark_img)
    watermark_img.destroy!
  end

  def check_image_size(src_image)
    size = src_image.image.size
    return if size <= MemeCaptainWeb::Config::MAX_SRC_IMAGE_SIZE
    fail(
      MemeCaptainWeb::Error::SrcImageTooBigError,
      "image is too large (#{size} bytes)")
  end
end
