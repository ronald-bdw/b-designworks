class FetchFitbitActivityJob < ActiveJob::Base
  queue_as :default

  def perform
    FitnessToken.source_fitbit.find_each do |fitness_token|
      result = FitnessTokens::FetchFitbitActivity.call(fitness_token: fitness_token)

      if result.success?
        SaveActivityBulk.call(
          params: activities(result.steps, fitness_token.source),
          user: fitness_token.user
        )
      end
    end
  end

  private

  def activities(steps, source)
    steps.map do |step|
      build_activity(step, source)
    end
  end

  def build_activity(step, source)
    date_time = step["dateTime"].to_datetime
    {
      started_at: date_time.beginning_of_day,
      finished_at: date_time.end_of_day,
      source: source,
      steps_count: step["value"].to_i
    }
  end
end
