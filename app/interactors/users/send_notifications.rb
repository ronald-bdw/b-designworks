module Users
  class SendNotifications
    include Interactor

    delegate :user, to: :context

    def call
      return unless user.sign_in_count == 1

      notification_subscribers.each do |subscriber|
        ::UsersMailer.first_login(subscriber.email, user).deliver_later
      end
    end

    private

    def notification_subscribers
      NotificationSubscriber.with_type("first_user_login")
    end
  end
end
