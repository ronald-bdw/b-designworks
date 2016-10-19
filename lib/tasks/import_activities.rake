#!/bin/env ruby
# encoding: utf-8

namespace :activites do
  desc "Fetch user activites from fitbit and googlefit"
  task import: :environment do
    FitnessToken.sources.keys.each do |type|
      "Fetch#{type.humanize}ActivityJob".classify.constantize.perform_now
    end
  end
end
