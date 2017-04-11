class SheetRow
  attr_reader :activity, :source, :interval, :new_user
  private :activity, :source, :interval, :new_user
  USER_ATTRIBUTES = %w(project_id first_name last_name email provider_name previous_provider_name).freeze

  def initialize(options)
    @activity = options[:activity]
    @new_user = options[:new_user]
    @source = options[:source]
    @interval = options[:interval]
  end

  def build
    [user_attributes, sources_list, steps_by_day].flatten
  end

  private

  def user_attributes
    return Array.new(USER_ATTRIBUTES.length, "") unless new_user

    USER_ATTRIBUTES.map do |field|
      default_value = (field == "previous_provider_name" ? "" : 0)

      activity[field] || default_value
    end
  end

  def empty_steps
    interval.reduce({}) { |month, (date)| month.merge!(date => 0) }
  end

  def steps_by_day
    empty_steps.merge(steps).values
  end

  def sources_list
    %i(fitbit googlefit healthkit).map do |type|
      DailyStep.sources[type] == source && steps.values.sum.positive? ? 1 : 0
    end
  end

  def steps
    JSON.parse(activity["steps"]).reduce({}) do |m, (k, v)|
      m.merge!(Date.parse(k) => v)
    end
  end
end
