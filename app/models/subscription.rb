class Subscription < ActiveRecord::Base
  belongs_to :user

  validates :plan_name, :expires_at, presence: true
end
