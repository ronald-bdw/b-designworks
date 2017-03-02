module Users
  class UpdateDailySteps
    include Interactor

    attr_reader :started_at, :finished_at

    delegate :activity, to: :context
    delegate :user, :source, to: :activity

    def call
      context.fail! unless user

      @started_at = activity.started_at.beginning_of_day
      @finished_at = activity.finished_at.end_of_day

      daily_step.steps_count = activities.sum(:steps_count)
      daily_step.provider = user.provider
      daily_step.save
    end

    def daily_step
      @step ||= user.daily_steps.find_or_initialize_by(
        started_at: started_at,
        finished_at: finished_at,
        source: Activity.sources[source]
      )
    end

    def activities
      user.activities.where(started_at: started_at..finished_at, source: source)
    end
  end
end
