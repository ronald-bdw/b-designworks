class AndroidSubscriptionsMailer < ActionMailer::Base
  default from: "from@b-designworks.com"

  def expiration_in_10_days(user)
    @user = user

    mail(to: user.email, subject: "B-Designworks subscription expiration in 10 days")
  end

  def expiration_in_24_hours(user)
    @user = user

    mail(to: user.email, subject: "B-Designworks subscription expiration in 24 hours")
  end
end
