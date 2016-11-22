module Users
  class Login
    include Interactor::Organizer

    organize UpdateToken, CleanData, SendNotifications
  end
end
