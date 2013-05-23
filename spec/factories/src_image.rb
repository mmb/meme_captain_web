FactoryGirl.define do

  factory :src_image do
    image File.open(Rails.root + 'spec/fixtures/files/ti_duck.jpg', 'rb') { |f| f.read }
  end

end
