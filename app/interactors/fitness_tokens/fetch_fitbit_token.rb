module FitnessTokens
  class FetchFitbitToken
    include Interactor

    delegate :fitness_token, to: :context

    def call
      prepare_token if fitness_token.source == "fitbit"
    end

    private

    def prepare_token
      if fitbit_request.success?
        context.fitbit_access_token = fitbit_request.access_token
        context.fitbit_refresh_token = fitbit_request.refresh_token
      else
        fitness_token.errors.add(:token, fitbit_request.errors)
        context.fail!
      end
    end

    def fitbit_request
      @request ||= FitbitRequest.new(
        authorization_code: fitness_token.authorization_code
      ).fetch_token
    end
  end
end
