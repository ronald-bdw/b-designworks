namespace :notify_about_subscription_expiration do
  desc "Notify users about subscription expiration in 10 days"
  task after_10_days: :environment do
    Users::NotifyAboutSubscriptionExpiration.call(expiration_time: "10_days")
  end

  desc "Notify users about subscription expiration in 24 hours"
  task after_24_hours: :environment do
    Users::NotifyAboutSubscriptionExpiration.call(expiration_time: "24_hours")
  end
end
