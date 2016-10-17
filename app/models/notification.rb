class Notification < ActiveRecord::Base
  belongs_to :user

  enum kind: %i(message_push)
end
