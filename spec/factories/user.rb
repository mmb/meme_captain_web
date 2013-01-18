FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password 'secret'
    password_confirmation 'secret'

    factory :invalid_user do
      email nil
    end

  end

end
