FactoryGirl.define do
  factory :auth_phone_code do
    phone_code { Faker::Number.number(4) }
    expire_at 1.minutes.from_now
  end
end
