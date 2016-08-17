module Users
  class Create
    include Interactor::Organizer

    organize Build, SaveAndCreateZendeskAccount
  end
end
