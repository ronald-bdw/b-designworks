class FetchFitbitActivityJob < ActiveJob::Base
  queue_as :default

  def perform
    FitnessToken.fitbit.find_each do |fitness_token|
      result = FitnessTokens::FetchActivity.call(fitness_token: fitness_token)

      if result.success? && result.steps.present?
        SaveActivityBulk.call(
          params: activities(result.steps),
          user: fitness_token.user
        )
      end
    end
  end

  private

  def activities(steps)
    steps.map do |step|
      build_activity(step)
    end
  end

  def build_activity(step)
    date_time = step["dateTime"].to_datetime
    {
      started_at: date_time.beginning_of_day,
      finished_at: date_time.end_of_day,
      source: "fitbit",
      steps_count: step["value"].to_i
    }
  end
end
