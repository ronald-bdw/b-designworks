FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    auth_phone_code
    email
    phone_number
    zendesk_id 1
    provider
    first_popup_active true
    second_popup_active false
  end
end
