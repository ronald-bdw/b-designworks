module Users
  class DisableNotifications
    include Interactor

    delegate :user, to: :context

    def call
      user&.notifications.delete_all
    end
  end
end
