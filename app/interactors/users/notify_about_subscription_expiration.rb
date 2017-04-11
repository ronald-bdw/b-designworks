module Users
  class NotifyAboutSubscriptionExpiration
    include Interactor

    def call
      AndroidSubscriptionExpirationUsers.new(expires_at).all.each do |user|
        AndroidSubscriptionsMailer.subscription_expiration(user).deliver_later
      end
    end

    private

    def expires_at
      (Time.now + 10.days).beginning_of_day..(Time.now + 10.days).end_of_day
    end
  end
end
