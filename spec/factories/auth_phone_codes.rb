FactoryGirl.define do
  factory :auth_phone_code do
    phone_code { Faker::Number.number(4) }
  end
end
