namespace :notify_about_subscription_expiration do
  desc "Notify users about subscription expiration in 10 days"
  task after_10_days: :environment do
    AndroidSubscriptionsMailer.expiration_in_10_days.deliver_now!
  end

  desc "Notify users about subscription expiration in 24 hours"
  task after_24_hours: :environment do
    AndroidSubscriptionsMailer.expiration_in_24_hours.deliver_now!
  end
end
