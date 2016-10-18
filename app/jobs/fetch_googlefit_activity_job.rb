class FetchGooglefitActivityJob < ActiveJob::Base
  queue_as :default

  def perform
    FitnessToken.source_googlefit.find_each do |fitness_token|
      result = FitnessTokens::FetchGooglefitActivity.call(fitness_token: fitness_token)

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
    {
      started_at: time_parse(step, "start"),
      finished_at: time_parse(step, "end"),
      source: source,
      steps_count: step["value"].map { |val| val[:intVal].to_i }.sum
    }
  end

  def time_parse(step, value)
    Time.at(step["#{value}TimeNanos"][0..9].to_i)
  end
end
