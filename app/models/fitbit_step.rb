class FitbitStep
  SOURCE = "fitbit".freeze

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def to_hash
    {
      started_at: date.beginning_of_day,
      finished_at: date.end_of_day,
      source: SOURCE,
      steps_count: steps_count
    }
  end

  private

  def date
    @date ||= params["dateTime"].to_datetime
  end

  def steps_count
    params["value"].to_i
  end
end
