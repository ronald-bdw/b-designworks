module Users
  class CleanData
    include Interactor::Organizer

    organize FitnessTokens::DeleteAll, DisableNotifications
  end
end
