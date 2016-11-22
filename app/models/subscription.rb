class Subscription < ActiveRecord::Base
  PLANS = %w(habit_starter habit_stabliser habit_master trial).freeze

  belongs_to :user

  validates :plan_name, :expires_at, presence: true
  validates :plan_name, inclusion: PLANS
end
