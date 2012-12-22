FactoryGirl.define do

  factory :gend_image do
    image File.read(Rails.root + 'spec/fixtures/files/ti_duck.jpg')
  end

end
