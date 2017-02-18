# encoding: UTF-8

require_relative '../support/fixture_file'

FactoryGirl.define do
  factory :src_image do
    image(fixture_file_data('ti_duck.jpg'))
    name('src image name')
  end

  factory :animated_src_image, parent: :src_image do
    image(fixture_file_data('omgcat.gif'))
  end

  factory :finished_src_image, parent: :src_image do
    work_in_progress(false)

    after(:create) do |src_image|
      img = src_image.magick_image_list
      img.resize_to_fill!(64, 64)
      src_image.create_src_thumb!(image: img.to_blob)
    end
  end

  factory :svg_src_image, parent: :src_image do
    image(fixture_file_data('thumbs_up.svg'))
  end

  factory :src_image_with_comment, parent: :src_image do
    image(fixture_file_data('ti_duck_with_comment.jpg'))
  end

  factory :src_image_with_orientation, parent: :src_image do
    image(fixture_file_data('rectangle.jpg'))
  end
end
