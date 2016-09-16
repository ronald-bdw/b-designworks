module FitnessTokens
  class FetchFitbitToken
    include Interactor

    delegate :fitness_token, :device_type, to: :context

    def call
      prepare_token if fitness_token.source == "fitbit"
    end

    private

    def prepare_token
      if fitbit_request.success?
        response = fitbit_request.response
        context.fitbit_access_token = response["access_token"]
        context.fitbit_refresh_token = response["refresh_token"]
      else
        fitness_token.errors.add(:token, fitbit_request.errors)
        context.fail!
      end
    end

    def fitbit_request
      @request ||= FitnessTokens::FitbitRequest.call(
        authorization_code: fitness_token.authorization_code,
        device_type: device_type
      )
    end
  end
end
