# encoding: UTF-8

require_relative '../support/fixture_file'

FactoryGirl.define do
  factory :gend_image do
    File.open(fixture_file('ti_duck.jpg'), 'rb') do |f|
      image(f.read)
    end
    src_image
    user
  end

  factory :animated_gend_image, parent: :gend_image do
    File.open(fixture_file('omgcat.gif'), 'rb') do |f|
      image(f.read)
    end
    association :src_image, factory: :animated_src_image
  end

  factory :finished_gend_image, parent: :gend_image do
    work_in_progress(false)

    after(:create) do |gend_image|
      img = gend_image.magick_image_list
      img.resize_to_fill!(64, 64)
      gend_image.create_gend_thumb!(image: img.to_blob)
    end
  end
end
