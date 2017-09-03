# frozen_string_literal: true

# Move a gend image to the external object store.
class GendImageMoveExternalJob
  attr_reader :gend_image_id
  attr_reader :bucket

  def initialize(gend_image_id, bucket)
    @gend_image_id = gend_image_id
    @bucket = bucket
  end

  def perform
    GendImage.find(gend_image_id).move_image_external(bucket)
  end
end
