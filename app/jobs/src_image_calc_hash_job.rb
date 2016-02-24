# frozen_string_literal: true

require 'digest/sha2'

# Job to calculate a hash of the image data.
class SrcImageCalcHashJob
  attr_reader :src_image_id

  def initialize(src_image_id)
    @src_image_id = src_image_id
  end

  def perform
    src_image = SrcImage.find(src_image_id)
    src_image.update!(image_hash: Digest::SHA2.new.hexdigest(src_image.image))
  end

  def max_attempts
    1
  end
end
