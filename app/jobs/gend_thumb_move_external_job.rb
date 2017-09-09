# frozen_string_literal: true

# Move a gend thumb to the external object store.
class GendThumbMoveExternalJob
  attr_reader :gend_thumb_id
  attr_reader :bucket

  def initialize(gend_thumb_id, bucket)
    @gend_thumb_id = gend_thumb_id
    @bucket = bucket
  end

  def perform
    GendThumb.find(gend_thumb_id).move_image_external(bucket)
  end
end
