class SaveActivityBulk
  include Interactor

  delegate :params, :user, to: :context

  def call
    invalid_data = []

    params.each do |data|
      activity = Activity.new(data.merge(user_id: user.id))
      invalid_data << data unless activity.save
    end

    return if invalid_data.empty?

    message = "Can't save activities: #{invalid_data}"
    context.fail!(message: message)
    Rollbar.info(message, user_id: user.id)
  end
end
