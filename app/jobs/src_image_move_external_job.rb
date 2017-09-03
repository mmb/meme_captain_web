# frozen_string_literal: true

# Move a src image to the external object store.
class SrcImageMoveExternalJob
  attr_reader :src_image_id
  attr_reader :bucket

  def initialize(src_image_id, bucket)
    @src_image_id = src_image_id
    @bucket = bucket
  end

  def perform
    SrcImage.find(src_image_id).move_image_external(bucket)
  end
end
