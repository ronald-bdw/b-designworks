module FitnessTokens
  class FetchFitbitSteps
    include Interactor

    delegate :fitness_token, to: :context

    def call
      if fitbit_request.success?
        context.steps = fitbit_request.steps
      else
        Rollbar.info(fitbit_request.errors)
        context.fail!
      end
    end

    private

    def fitbit_request
      @request ||= FitbitRequest.new(fitness_token: fitness_token).fetch_activities
    end
  end
end
