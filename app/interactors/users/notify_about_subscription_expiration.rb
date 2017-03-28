module Users
  class NotifyAboutSubscriptionExpiration
    include Interactor

    def call
      users.each do |user|
        AndroidSubscriptionsMailer.expiration_in_10_days(user).deliver_now!
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
      (Time.now + 10.days).beginning_of_day..(Time.now + 10.days).end_of_day
    end
  end
end
