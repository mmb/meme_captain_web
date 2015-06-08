# encoding: UTF-8

FactoryGirl.define do
  factory :gend_image do
    File.open(Rails.root + 'spec/fixtures/files/ti_duck.jpg', 'rb') do |f|
      image(f.read)
    end
    src_image
    user
  end
end
