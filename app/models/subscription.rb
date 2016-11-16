class Subscription < ActiveRecord::Base
  PLANS = %w(monthly trial).freeze

  belongs_to :user

  validates :plan_name, :expires_at, presence: true
  validates :plan_name, inclusion: PLANS
end
