class AndroidSubscriptionsMailer < ActionMailer::Base
  default from: "from@b-designworks.com"

  def subscription_expiration(user)
    @user = user

    mail(to: user.email, subject: "B-Designworks subscription expiration in 10 days")
  end

  def urgent_subscription_expiration(user)
    @user = user

    mail(to: user.email, subject: "B-Designworks subscription expiration in 24 hours")
  end
end
