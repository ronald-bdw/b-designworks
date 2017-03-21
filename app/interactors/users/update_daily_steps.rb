module Users
  class UpdateDailySteps
    include Interactor

    delegate :activity, to: :context
    delegate :user, :source, to: :activity

    def call
      context.fail! unless user

      daily_step.steps_count = steps_count
      daily_step.provider = user.provider
      daily_step.save
    end

    private

    def daily_step
      @daily_step ||= user.daily_steps.find_or_initialize_by(
        started_at: started_at,
        finished_at: finished_at,
        source: Activity.sources[source]
      )
    end

    def steps_count
      user
        .activities
        .where(started_at: started_at..finished_at, source: Activity.sources[source])
        .sum(:steps_count)
    end

    def started_at
      @started_at ||= activity.started_at.beginning_of_day
    end

    def finished_at
      @finished_at ||= activity.finished_at.end_of_day
    end
  end
end
