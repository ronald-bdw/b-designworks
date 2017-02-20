class Subscription < ActiveRecord::Base
  PLANS = %w(habit_starter habit_stabilizer habit_master trial).freeze

  belongs_to :user

  validates :plan_name, :expires_at, presence: true
  validates :plan_name, inclusion: PLANS

  def expire!
    update(active: false)
  end
end
