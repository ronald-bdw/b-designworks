class ActivitiesSum
  def self.create(activities:, count: nil, period: :day)
    sum_of_steps = activities.group_by_period(period, :finished_at, last: count).sum(:steps_count)

    sum_of_steps.map { |date, steps_count| new(date, steps_count) }
  end

  def initialize(date, steps_count)
    @date = date
    @steps_count = steps_count
  end
end
