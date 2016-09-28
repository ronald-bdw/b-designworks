class FetchFitbitActivityJob < ActiveJob::Base
  queue_as :default

  def perform
    FitnessToken.source_fitbit.find_each do |fitness_token|
      result = FitnessTokens::FetchFitbitActivity.call(fitness_token: fitness_token)

      if result.success?
        user = fitness_token.user
        create_fitbit_activities(user, result.steps, fitness_token.source)
      end
    end
  end

  private

  def create_fitbit_activities(user, steps, source)
    steps.each do |step|
      update_or_create_activity(user, step, source)
    end
  end

  def update_or_create_activity(user, step, source)
    date_time = step["dateTime"].to_datetime
    activity = user.activities.find_or_initialize_by(
      started_at: date_time.beginning_of_day,
      finished_at: date_time.end_of_day,
      source: source
    )
    activity&.steps_count = step["value"].to_i
    activity.save
  end
end
