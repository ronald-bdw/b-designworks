FactoryGirl.define do
  factory :activity do
    started_at { 1.day.ago }
    finished_at { Time.zone.now }
    steps_count 1000
    source "healthkit"
    user
  end
end
