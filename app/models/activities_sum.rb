class ActivitiesSum < Struct.new(:date, :steps_count)
  def self.initialize(activities:, count: nil)
    sum_of_steps = activities.group_by_day(:finished_at, last: count).sum(:steps_count)

    sum_of_steps.map { |date, steps_count| new(date, steps_count) }
  end
end
