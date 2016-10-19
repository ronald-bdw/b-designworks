class FetchGooglefitActivityJob < ActiveJob::Base
  queue_as :default

  def perform
    FitnessToken.googlefit.find_each do |fitness_token|
      result = FitnessTokens::FetchGooglefitActivity.call(fitness_token: fitness_token)

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
    {
      started_at: time_parse(step, "start"),
      finished_at: time_parse(step, "end"),
      source: "googlefit",
      steps_count: step["value"].map { |val| val[:intVal].to_i }.sum
    }
  end

  def time_parse(step, value)
    Time.at(step["#{value}TimeNanos"][0..9].to_i)
  end
end
