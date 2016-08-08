FactoryGirl.define do
  factory :user do
    auth_phone_code
    email
    password
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
