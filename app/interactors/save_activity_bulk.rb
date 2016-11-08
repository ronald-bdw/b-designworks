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
      activity_params = data.except(:steps_count).merge(source: Activity.sources[data[:source]])
      activity = user.activities.find_or_initialize_by(activity_params)
      activity.steps_count = data[:steps_count].to_i
      invalid_data << data unless activity.save
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
