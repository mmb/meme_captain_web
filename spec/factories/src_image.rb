# encoding: UTF-8

FactoryGirl.define do

  factory :src_image do
    image File.read(Rails.root + 'spec/fixtures/files/ti_duck.jpg')
  end

end
