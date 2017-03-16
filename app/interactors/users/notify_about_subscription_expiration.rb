module Users
  class NotifyAboutSubscriptionExpiration
    include Interactor

    delegate :expiration_time, to: :context

    def call
      users.where(subscriptions: { expires_at: send("expires_after_#{expiration_time}") }).each do |user|
        AndroidSubscriptionsMailer.send("expiration_in_#{expiration_time}", user).deliver_now!
      end
    end

    private

    def users
      User.includes(:subscription).where.not(subscriptions: { id: nil }).where(device: "android")
    end

    def expires_after_10_days
      (Time.now + 10.days).beginning_of_day..(Time.now + 10.days).end_of_day
    end

    def expires_after_24_hours
      (Time.now + 1.days)..(Time.now + 1.days + 1.hour)
    end
  end
end
