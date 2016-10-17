class Notification < ActiveRecord::Base
  belongs_to :user

  enum kind: %i(message_push)

  validates :kind, uniqueness: { scope: :user }
end
