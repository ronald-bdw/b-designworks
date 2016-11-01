# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    user
    plan_name "My plan"
    expires_at "2016-11-01 12:18:08"
    active false
  end
end
