module FitnessTokens
  class Save
    include Interactor

    delegate :fitness_token, :fitbit_access_token, :fitbit_refresh_token, to: :context

    def call
      if fitbit_access_token
        fitness_token.token = fitbit_access_token
        fitness_token.refresh_token = fitbit_refresh_token
      end
      fitness_token.save
    end
  end
end
