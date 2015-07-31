# encoding: UTF-8

FactoryGirl.define do
  factory :src_image do
    File.open(Rails.root + 'spec/fixtures/files/ti_duck.jpg', 'rb') do |f|
      image(f.read)
    end
  end

  factory :animated_src_image, parent: :src_image do
    File.open(Rails.root + 'spec/fixtures/files/omgcat.gif', 'rb') do |f|
      image(f.read)
    end
  end
end
