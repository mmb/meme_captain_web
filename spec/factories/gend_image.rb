FactoryGirl.define do

  factory :gend_image do
    image File.open(Rails.root + 'spec/fixtures/files/ti_duck.jpg', 'rb') { |f| f.read }
    src_image
    user
  end

end
