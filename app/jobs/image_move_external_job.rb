# frozen_string_literal: true

# Move an image to the external object store.
class ImageMoveExternalJob
  attr_reader :klass
  attr_reader :image_id
  attr_reader :bucket

  def initialize(klass, image_id, bucket)
    @klass = klass
    @image_id = image_id
    @bucket = bucket
  end

  def perform
    klass.find(image_id).move_image_external(bucket)
  end
end
