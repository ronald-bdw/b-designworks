FactoryGirl.define do
  factory :notification_subscriber do
    email { Faker::Internet.email }
    notification_types ["first_user_login"]
  end
end
