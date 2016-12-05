module Users
  class NotifyUserRegistration
    include Interactor

    delegate :user, to: :context

    def call
      notification_subscribers.each do |subscriber|
        ::UsersMailer.registration_complete(subscriber.email, user).deliver_later
      end
    end

    private

    def notification_subscribers
      NotificationSubscriber.with_type("registration_complete")
    end
  end
end
