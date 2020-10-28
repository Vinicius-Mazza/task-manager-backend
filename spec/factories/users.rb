FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "3301"
    password_confirmation "3301"
  end
end