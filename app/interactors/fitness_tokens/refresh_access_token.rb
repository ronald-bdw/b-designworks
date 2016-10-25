module FitnessTokens
  class RefreshAccessToken
    include Interactor

    delegate :fitness_token, to: :context

    def call
      if response.success?
        fitness_token.token = response.access_token
        fitness_token.refresh_token = response.refresh_token if response.refresh_token.present?
        fitness_token.save
      else
        Rollbar.info(response.errors)
        delete_fitness_token if response.invalid_refresh_token?
        context.fail!
      end
    end

    private

    def delete_fitness_token
      fitness_token.destroy

      Rails.logger.info(
        I18n.t(
          "fitness_token.deleted_with_invalid_refresh_token",
          source: fitness_token.source,
          user_id: fitness_token.user.id
        )
      )
    end

    def response
      @response ||= request_klass.new(fitness_token: fitness_token).refresh_access_token
    end

    def request_klass
      @klass ||= "#{fitness_token.source.classify}Request".constantize
    end
  end
end
