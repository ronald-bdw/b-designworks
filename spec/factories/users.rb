FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    auth_phone_code
    email
    phone_number { Faker::PhoneNumber.cell_phone }
    zendesk_id 1
  end
end
