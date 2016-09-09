class Activity < ActiveRecord::Base
  belongs_to :user

  enum source: %i(healthkit googlefit fitbit)

  validates :started_at, :finished_at, :steps_count, :user, :source, presence: true
  validates :steps_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :order_by_finished_at, -> { order(finished_at: :asc) }
end
