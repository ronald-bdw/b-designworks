class ZendeskMailer < ActionMailer::Base
  default from: "from@b-designworks.com"

  def users_synchronized(notify_email)
    mail(to: notify_email, subject: "Users are imported")
  end
end
