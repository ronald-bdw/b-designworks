module FitnessTokens
  class Create
    include Interactor::Organizer

    organize FetchFitbitToken, Save
  end
end
