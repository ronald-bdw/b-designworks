class GooglefitStep
  SOURCE = "googlefit".freeze

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def to_hash
    {
      started_at: started_at,
      finished_at: finished_at,
      source: SOURCE,
      steps_count: steps_count
    }
  end

  private

  def started_at
    Time.at(params["startTimeNanos"][0..9].to_i)
  end

  def finished_at
    Time.at(params["endTimeNanos"][0..9].to_i)
  end

  def steps_count
    params["value"].map { |val| val["intVal"].to_i }.sum
  end
end
