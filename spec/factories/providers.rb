FactoryGirl.define do
  factory :provider do
    name { Faker::Lorem.word }
    zendesk_id 1
    priority
    first_popup_message { Faker::Lorem.sentence }
    second_popup_message { Faker::Lorem.sentence }
  end
end
