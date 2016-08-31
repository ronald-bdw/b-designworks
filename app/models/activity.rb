class Activity < ActiveRecord::Base
  belongs_to :user

  validates :started_at, :finished_at, :steps_count, :user, presence: true
  validates :steps_count, numericality: { only_integer: true, greater_than: 0 }
end
