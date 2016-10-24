module FitnessTokens
  class FetchActivity
    include Interactor::Organizer

    organize RefreshAccessToken, FetchSteps
  end
end
