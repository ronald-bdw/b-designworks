FactoryGirl.define do
  factory :user do
    email
    password
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
