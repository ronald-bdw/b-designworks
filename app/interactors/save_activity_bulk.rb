class SaveActivityBulk
  include Interactor

  delegate :activities, :user, to: :context

  def call
    activities.each do |data|
      activity = Activity.new(activity_params(data))
      context.fail!(message: "Data is not valid") unless activity.save
    end
  end

  private

  def activity_params(data)
    data.merge(user_id: user.id)
  end
end
