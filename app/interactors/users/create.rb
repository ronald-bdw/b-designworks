module Users
  class Create
    include Interactor::Organizer

    organize ValidateAndSave, CreateZendeskAccount
  end
end
