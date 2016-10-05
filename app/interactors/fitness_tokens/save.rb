module FitnessTokens
  class Save
    include Interactor

    delegate :fitness_token, :access_token, :refresh_token, to: :context

    def call
      if access_token
        fitness_token.token = access_token
        fitness_token.refresh_token = refresh_token
      end
      fitness_token.save
    end
  end
end
