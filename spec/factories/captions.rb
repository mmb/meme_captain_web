# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :caption do
    text 'MyString'
    font 'MyString'
    top_left_x_pct 1.5
    top_left_y_pct 1.5
    width_pct 1.5
    height_pct 1.5
    gend_image nil
  end
end
