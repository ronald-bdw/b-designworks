class SaveActivityBulk
  include Interactor

  before do
    context.invalid_data = []
  end

  delegate :params, :user, :invalid_data, to: :context

  def call
    create_activities
    check_for_errors
  end

  private

  def create_activities
    params.each do |data|
      next unless check_attributes(data)

      activity = user.activities.find_or_initialize_by(finder_attributes(data))
      activity.steps_count = data[:steps_count].to_i
      invalid_data << data unless activity.save
    end
  end

  def finder_attributes(attrs)
    {
      started_at: Time.zone.parse(attrs[:started_at].to_s).utc,
      finished_at: Time.zone.parse(attrs[:finished_at].to_s).utc,
      source: Activity.sources[attrs[:source]]
    }
  end

  def check_attributes(attrs)
    if attrs[:started_at].nil? || attrs[:finished_at].nil?
      invalid_data << attrs

      false
    else
      true
    end
  end

  def check_for_errors
    return if invalid_data.empty?

    context.error = error
    Rollbar.info(context.error, user_id: user.id)
    context.fail!
  end

  def error
    RailsApiFormat::Error.new(
      status: :unprocessable_entity,
      error: I18n.t("activity.errors.invalid_data", data: invalid_data)
    )
  end
end
