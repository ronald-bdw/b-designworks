FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:password) { "123456" }
  sequence(:phone_number) { "+1-727-819-#{rand(1000..9999)}" }
  sequence(:priority) { rand(1..20) }
end
