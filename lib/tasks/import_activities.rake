#!/bin/env ruby
# encoding: utf-8

namespace :activites do
  desc "Fetch users activites"
  task import: :environment do
    FitnessToken.sources.keys.each do |type|
      FetchActivitiesJob.perform_now
    end
  end
end
