class FetchActivitiesJob < ActiveJob::Base
  queue_as :default

  DEFAULT_PERIOD = 1.hour.freeze

  def perform(params = {})
    parse_params(params)

    fitness_tokens.find_each do |fitness_token|
      result = FitnessTokens::FetchActivity.call(build_params(fitness_token))

      if result.success? && result.steps.present?
        SaveActivityBulk.call(
          params: build_activities(result.steps, fitness_token.source),
          user: fitness_token.user
        )
      end
    end
  end

  private

  def parse_params(params)
    @fitness_token_id = params[:fitness_token_id]
    @period = params[:period]
  end

  def period
    @period || DEFAULT_PERIOD
  end

  def fitness_tokens
    return FitnessToken.all if @fitness_token_id.nil?

    FitnessToken.where(id: @fitness_token_id)
  end

  def build_params(fitness_token)
    {
      fitness_token: fitness_token,
      started_at: Time.current - period,
      finished_at: Time.current
    }
  end

  def build_activities(steps, source)
    builder_klass = "#{source.capitalize}Step".constantize

    steps.map { |step| builder_klass.new(step).to_hash }
  end
end
