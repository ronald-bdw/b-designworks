#!/bin/env ruby
# encoding: utf-8

namespace :activites do
  desc "Fetch users activites"
  task import: :environment do
    FetchActivitiesJob.perform_now
  end

  desc "Fetch users activites for last 3 days"
  task import_last_3_days: :environment do
    FetchActivitiesJob.perform_now(period: 3.day)
  end

  desc "Refresh daily steps count"
  task update_daily_steps: :environment do
    Activity.find_each do |activity|
      Users::UpdateDailySteps.call(activity: activity)
    end
  end
end
