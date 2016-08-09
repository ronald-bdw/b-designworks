FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
    auth_phone_code
    email
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
