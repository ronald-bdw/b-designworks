module FitnessTokens
  class Save
    include Interactor

    delegate :fitness_token, :access_token, :refresh_token, to: :context

    def call
      if access_token
        fitness_token.token = access_token
        fitness_token.refresh_token = refresh_token
      end

      fetch_init_acitivities if fitness_token.save
    end

    private

    def fetch_init_acitivities
      FetchActivitiesJob.perform_later(
        fitness_token_id: fitness_token.id,
        period: 1.week.to_i
      )
    end
  end
end
