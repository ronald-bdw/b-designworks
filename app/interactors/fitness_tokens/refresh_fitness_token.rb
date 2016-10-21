module FitnessTokens
  class RefreshFitnessToken
    include Interactor

    delegate :fitness_token, to: :context

    def call
      if response.success?
        fitness_token.token = response.access_token
        fitness_token.refresh_token = response.refresh_token
        fitness_token.save
      else
        Rollbar.info(fitbit_response.errors)
        context.fail!
      end
    end

    private

    def response
      @response ||= request_klass.new(fitness_token: fitness_token).refresh_access_token
    end

    def request_klass
      @klass ||= "#{fitness_token.source.classify}Request".constantize
    end
  end
end
