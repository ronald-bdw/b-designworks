module Users
  class UrgentNotifyAboutSubscriptionExpiration
    include Interactor

    def call
      users.each do |user|
        AndroidSubscriptionsMailer.expiration_in_24_hours(user).deliver_now!
      end
    end

    private

    def users
      User
        .includes(:subscription)
        .where.not(subscriptions: { id: nil, active: false })
        .where(device: "android", subscriptions: { expires_at: expires_after })
    end

    def expires_after
      (Time.now + 1.days)..(Time.now + 1.days + 1.hour)
    end
  end
end
