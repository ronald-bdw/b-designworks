module V1
  class ActivitiesController < ApplicationController
    wrap_parameters :activity

    acts_as_token_authentication_handler_for User

    expose(:activities, ancestor: :current_user)
    expose(:activity, attributes: :activity_params)

    def create
      activity.save

      respond_with activity
    end

    def index
      self.activities = ActivitiesSum.initialize(activities: activities, count: params[:count])

      respond_with activities, serializer: ActivitiesSumSerializer
    end

    private

    def activity_params
      params.require(:activity).permit(:started_at, :finished_at, :steps_count)
    end
  end
end
