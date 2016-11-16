FactoryGirl.define do
  factory :subscription do
    user
    plan_name "trial"
    expires_at "2016-11-01 12:18:08"
    active false
  end
end
