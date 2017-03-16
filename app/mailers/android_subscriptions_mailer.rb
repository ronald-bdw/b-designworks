class AndroidSubscriptionsMailer < ActionMailer::Base
  DATE_INTERVALS = %w(10_days 24_hours).freeze

  default from: "from@b-designworks.com"

  DATE_INTERVALS.each do |interval|
    define_method("expiration_in_#{interval}") do
      users.where(subscriptions: { expires_at: send("expires_after_#{interval}") }).each do |user|
        @user = user

        mail(to: user.email, subject: "B-Designworks subscription expiration")
      end
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
