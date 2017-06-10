# frozen_string_literal: true

# Job to fetch and normalize source images and create thumbnails.
class SrcImageProcessJob
  attr_reader :src_image_id

  def initialize(src_image_id)
    @src_image_id = src_image_id
  end

  def perform
    src_image = SrcImage.find(src_image_id)
    src_image.load_from_url

    shrink_large_animated(src_image)

    check_image_size(src_image)

    process_src_image(src_image)

    src_image.set_derived_image_fields

    src_image.update!(work_in_progress: false)

    enqueue_jobs(src_image)
  end

  def reschedule_at(current_time, _attempts)
    current_time + 1.second
  end

  def max_attempts
    1
  end

  def failure(job)
    return if job.last_error.blank?
    src_image = SrcImage.without_image.find(src_image_id)
    error = job.last_error.split("\n".freeze).first
    src_image.update_attribute(:error, error)
  end

  private

  def shrink_large_animated(src_image)
    return unless shrink_animated?(src_image)

    coalescer = MemeCaptainWeb::AnimatedGifCoalescer.new
    trimmer = MemeCaptainWeb::AnimatedGifTrimmer.new
    shrinker = MemeCaptainWeb::AnimatedGifShrinker.new(coalescer, trimmer)
    shrinker.shrink(
      src_image.image,
      MemeCaptainWeb::Config::MAX_SRC_IMAGE_SIZE
    ) do |data|
      src_image.image = data
    end
  end

  def shrink_animated?(src_image)
    src_image.image.start_with?('GIF'.freeze) &&
      src_image.image.size > MemeCaptainWeb::Config::MAX_SRC_IMAGE_SIZE &&
      src_image.image.size <= MemeCaptainWeb::Config::MAX_GIF_SHRINK_SIZE
  end

  def process_src_image(src_image)
    img = src_image.magick_image_list

    MemeCaptainWeb::ImageFormatConverter.new.convert(img)

    img.auto_orient!
    img.strip!

    MemeCaptainWeb::ImgSizeConstrainer.new.constrain_size(img)

    create_thumbnail(src_image, img)

    watermark(img)

    src_image.image = img.to_blob

    img.destroy!
  end

  def check_image_size(src_image)
    size = src_image.image.size
    return if size <= MemeCaptainWeb::Config::MAX_SRC_IMAGE_SIZE
    raise(MemeCaptainWeb::Error::SrcImageTooBigError, size)
  end

  def create_thumbnail(src_image, img)
    thumb_img = img.resize_to_fill_anim(MemeCaptainWeb::Config::THUMB_SIDE)
    src_image.create_src_thumb(image: thumb_img.to_blob)
    thumb_img.destroy!
  end

  def watermark(img)
    watermark_img = Magick::ImageList.new(
      Rails.root + 'app/assets/images/watermark.png'.freeze
    )
    img.extend(MemeCaptain::ImageList::Watermark)
    img.watermark_mc(watermark_img)
    watermark_img.destroy!
  end

  def enqueue_jobs(src_image)
    SrcImageNameJob.new(src_image.id).delay(queue: :src_image_name).perform
    SrcImageCalcHashJob.new(src_image.id).delay(queue: :calc_hash).perform
  end
end
