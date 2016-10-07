module FitnessTokens
  class FetchToken
    include Interactor

    delegate :fitness_token, to: :context

    def call
      if token_request.success?
        context.access_token = token_request.access_token
        context.refresh_token = token_request.refresh_token
      else
        fitness_token.errors.add(:token, token_request.errors)
        context.fail!
      end
    end

    private

    def token_request
      @request ||= "#{fitness_token.source}Request".classify.constantize.new(
        authorization_code: fitness_token.authorization_code
      ).fetch_token
    end
  end
end
