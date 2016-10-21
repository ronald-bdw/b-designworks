module FitnessTokens
  class FetchFitbitActivity
    include Interactor::Organizer

    organize RefreshFitnessToken, FetchFitbitSteps
  end
end
