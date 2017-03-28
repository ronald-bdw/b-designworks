namespace :notify_about do
  desc "Notify users about subscription expiration in 10 days"
  task subscription_expiration: :environment do
    Users::NotifyAboutSubscriptionExpiration.call
  end

  desc "Notify users about subscription expiration in 24 hours"
  task urgent_subscription_expiration: :environment do
    Users::UrgentNotifyAboutSubscriptionExpiration.call
  end
end
