module Users
  class UrgentNotifyAboutSubscriptionExpiration
    include Interactor

    def call
      AndroidSubscriptionExpirationUsers.new(expires_at).all.each do |user|
        AndroidSubscriptionsMailer.urgent_subscription_expiration(user).deliver_later
      end
    end

    private

    def expires_at
      (Time.now + 1.days)..(Time.now + 1.days + 1.hour)
    end
  end
end
