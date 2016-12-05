class UsersMailer < ActionMailer::Base
  default from: "from@b-designworks.com"

  def first_login(notify_email, user)
    @user = user

    mail(to: notify_email, subject: "New user logged in")
  end

  def registration_complete(notify_email, user)
    @user = user

    mail(to: notify_email, subject: "New user registered")
  end
end
