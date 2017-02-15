# frozen_string_literal: true

# Job to calculate a hash of the image data.
class SrcImageCalcHashJob
  attr_reader :src_image_id

  def initialize(src_image_id)
    @src_image_id = src_image_id
  end

  def perform
    SrcImage.find(src_image_id).set_image_hash
  end

  def max_attempts
    1
  end
end
