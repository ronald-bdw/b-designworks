module Users
  class Create
    include Interactor::Organizer

    organize Build, SaveAndCreateZendeskAccount, NotifyUserRegistration
  end
end
