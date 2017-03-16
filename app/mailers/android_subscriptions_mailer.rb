class AndroidSubscriptionsMailer < ActionMailer::Base
  DATE_INTERVALS = %w(10_days 24_hours).freeze

  default from: "from@b-designworks.com"

  DATE_INTERVALS.each do |interval|
    define_method("expiration_in_#{interval}") do |user|
      @user = user

      mail(to: user.email, subject: "B-Designworks subscription expiration")
    end
  end
end
