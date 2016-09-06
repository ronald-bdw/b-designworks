module V1
  class ActivitiesController < ApplicationController
    wrap_parameters :activity

    acts_as_token_authentication_handler_for User, only: %i(create)

    before_action :authorize_zendesk_app!, only: %i(index)

    expose(:activities, ancestor: :current_user)
    expose(:activity, attributes: :activity_params)

    def create
      activity.save

      respond_with activity
    end

    def index
      result = Activities::FindAndSummarize.call(params: params)

      if result.success?
        respond_with result.activities, serializer: ActiveModel::Serializer::ArraySerializer
      else
        render json: result.error, status: result.error.status
      end
    end

    private

    def activity_params
      params.require(:activity).permit(:started_at, :finished_at, :steps_count)
    end
  end
end
