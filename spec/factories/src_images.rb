# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :src_image do
    id_hash ""
    url "MyString"
    width 1
    height 1
    size 1
    format "MyString"
    image ""
    src_thumb ""
    user ""
  end
end
