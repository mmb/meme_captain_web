# frozen_string_literal: true

# Move a src thumb to the external object store.
class SrcThumbMoveExternalJob
  attr_reader :src_thumb_id
  attr_reader :bucket

  def initialize(src_thumb_id, bucket)
    @src_thumb_id = src_thumb_id
    @bucket = bucket
  end

  def perform
    SrcThumb.find(src_thumb_id).move_image_external(bucket)
  end
end
