# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :daily_step do
    user
    source 1
    steps_count 1
    started_at ""
    finished_at "2017-03-01 15:20:01"
  end
end
