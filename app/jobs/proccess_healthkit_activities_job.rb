class ProccessHealthkitActivitiesJob < ActiveJob::Base
  queue_as :default

  def perform(activities, user)
    SaveActivityBulk.call(params: activities, user: user)
  end
end
