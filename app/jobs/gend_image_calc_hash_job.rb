# frozen_string_literal: true

# Job to calculate a hash of the image data.
class GendImageCalcHashJob
  attr_reader :gend_image_id

  def initialize(gend_image_id)
    @gend_image_id = gend_image_id
  end

  def perform
    GendImage.find(gend_image_id).set_image_hash
  end

  def max_attempts
    1
  end
end
