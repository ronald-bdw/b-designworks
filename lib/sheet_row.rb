class SheetRow
  attr_reader :activity, :source, :interval, :new_user
  private :activity, :source, :interval, :new_user

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
    %w(project_id first_name last_name email provider_name).map do |field|
      if new_user
        activity[field] || 0
      else
        ""
      end
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
