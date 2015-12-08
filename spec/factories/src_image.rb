# encoding: UTF-8

FactoryGirl.define do
  factory :src_image do
    File.open(Rails.root + 'spec/fixtures/files/ti_duck.jpg', 'rb') do |f|
      image(f.read)
    end
    name('src image name')
  end

  factory :animated_src_image, parent: :src_image do
    File.open(Rails.root + 'spec/fixtures/files/omgcat.gif', 'rb') do |f|
      image(f.read)
    end
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
    File.open(Rails.root + 'spec/fixtures/files/thumbs_up.svg', 'rb') do |f|
      image(f.read)
    end
  end

  factory :src_image_with_comment, parent: :src_image do
    File.open(
      Rails.root + 'spec/fixtures/files/ti_duck_with_comment.jpg', 'rb') do |f|
      image(f.read)
    end
  end

  factory :src_image_with_orientation, parent: :src_image do
    File.open(
      Rails.root + 'spec/fixtures/files/rectangle.jpg', 'rb') do |f|
      image(f.read)
    end
  end
end
