# encoding: UTF-8

FactoryGirl.define do
  factory :gend_image do
    File.open(Rails.root + 'spec/fixtures/files/ti_duck.jpg', 'rb') do |f|
      image(f.read)
    end
    src_image
    user
  end

  factory :animated_gend_image, parent: :gend_image do
    File.open(Rails.root + 'spec/fixtures/files/omgcat.gif', 'rb') do |f|
      image(f.read)
    end
    association :src_image, factory: :animated_src_image
  end
end
