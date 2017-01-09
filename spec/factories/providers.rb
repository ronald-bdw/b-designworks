FactoryGirl.define do
  factory :provider do
    name { Faker::Lorem.word }
    zendesk_id 1
  end
end
