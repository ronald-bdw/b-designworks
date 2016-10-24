module FitnessTokens
  class FetchSteps
    include Interactor

    delegate :fitness_token, to: :context

    def call
      if response.success?
        context.steps = response.steps
      else
        Rollbar.info(response.errors)
        context.fail!
      end
    end

    private

    def response
      @response ||= request_klass.new(
        fitness_token: fitness_token,
        started_at: Time.current - 1.hour,
        finished_at: Time.current
      ).fetch_activities
    end

    def request_klass
      @klass ||= "#{fitness_token.source.classify}Request".constantize
    end
  end
end
