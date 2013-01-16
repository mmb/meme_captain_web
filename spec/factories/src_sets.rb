# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :src_set do
    sequence(:name) { |n| "set#{n}" }
    user nil
  end
end
