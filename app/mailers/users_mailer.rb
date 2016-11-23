class UsersMailer < ActionMailer::Base
  default from: "from@b-designworks.com"

  def first_login(notify_email, user)
    @user = user

    mail(to: notify_email, subject: "New user logged in")
  end
end
