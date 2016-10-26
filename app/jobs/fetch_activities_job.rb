class FetchActivitiesJob < ActiveJob::Base
  queue_as :default

  def perform(params = {})
    FitnessToken.find_each do |fitness_token|
      result = FitnessTokens::FetchActivity.call(fitness_token: fitness_token)

      if result.success? && result.steps.present?
        SaveActivityBulk.call(
          params: build_activities(result.steps, fitness_token.source),
          user: fitness_token.user
        )
      end
    end
  end

  private

  def build_activities(steps, source)
    builder_klass = "#{source.capitalize}Step".constantize

    steps.map { |step| builder_klass.new(step).to_hash }
  end
end
