module FitnessTokens
  class FetchFitbitActivity
    include Interactor

    delegate :fitness_token, to: :context

    def call
      if fitbit_request.success?
        context.steps = fitbit_request.steps
      else
        fitness_token.errors.add(:token, fitbit_request.errors)
        context.fail!
      end
    end

    private

    def fitbit_request
      @request ||= FitbitRequest.new(
        token: fitness_token.token
      ).fetch_activities
    end
  end
end
