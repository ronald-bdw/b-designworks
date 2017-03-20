class UserDailySteps
  attr_reader :provider_id, :interval
  private :provider_id, :interval

  def initialize(provider_id, interval)
    @provider_id = provider_id
    @interval = interval
  end

  def all
    ActiveRecord::Base.connection.execute(query)
  end

  private

  def query
    <<~SQL
      SELECT user_id, users.project_id, users.first_name, users.last_name, users.email, providers.name as provider_name,
        daily_steps.source, json_object_agg(daily_steps.started_at, daily_steps.steps_count) as steps
        FROM daily_steps INNER JOIN users ON users.id = daily_steps.user_id
        INNER JOIN providers ON providers.id = daily_steps.provider_id
        WHERE daily_steps.provider_id = #{provider_id} AND steps_count > 0 AND
        (daily_steps.started_at BETWEEN '#{interval.first.beginning_of_month.to_datetime}' AND '#{interval.last.end_of_month.to_datetime}')
        GROUP BY user_id, users.project_id, users.first_name, users.last_name, users.email, providers.name, daily_steps.source
        ORDER BY users.first_name
    SQL
  end
end
