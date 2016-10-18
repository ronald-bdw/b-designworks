module FitnessTokens
  class FetchGooglefitActivity
    include Interactor

    delegate :fitness_token, to: :context

    def call
      if googlefit_request.success?
        context.steps = googlefit_request.steps
      else
        fitness_token.errors.add(:token, googlefit_request.errors)
        context.fail!
      end
    end

    private

    def googlefit_request
      @request ||= GooglefitRequest.new(
        token: fitness_token.token
      ).fetch_activities
    end
  end
end
