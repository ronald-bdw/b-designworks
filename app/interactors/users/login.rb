module Users
  class Login
    include Interactor::Organizer

    organize UpdateToken, CleanData, SendNotifications, UpdateDevice
  end
end
