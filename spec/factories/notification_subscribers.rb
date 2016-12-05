FactoryGirl.define do
  factory :notification_subscriber do
    email { Faker::Internet.email }
    notification_types %w(first_user_login registration_complete)
  end
end
