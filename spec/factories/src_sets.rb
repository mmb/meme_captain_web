# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :src_set do
    sequence(:name) { |n| "set#{n}" }
    user

    factory :src_set_with_src_image do
      src_images { [create(:src_image)] }
    end
  end
end
