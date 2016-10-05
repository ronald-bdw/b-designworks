module FitnessTokens
  class Create
    include Interactor::Organizer

    organize FetchToken, Save
  end
end
