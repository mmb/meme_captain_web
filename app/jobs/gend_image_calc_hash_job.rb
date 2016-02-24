# frozen_string_literal: true

require 'digest/sha2'

# Job to calculate a hash of the image data.
class GendImageCalcHashJob
  attr_reader :gend_image_id

  def initialize(gend_image_id)
    @gend_image_id = gend_image_id
  end

  def perform
    gend_image = GendImage.find(gend_image_id)
    gend_image.update!(image_hash: Digest::SHA2.new.hexdigest(gend_image.image))
  end

  def max_attempts
    1
  end
end
