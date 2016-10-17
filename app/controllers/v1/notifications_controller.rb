module V1
  class NotificationsController < ApplicationController
    acts_as_token_authentication_handler_for User

    expose(:notifications, ancestor: :current_user)
    expose(:notification, attributes: :notification_params, finder: :find_by_kind)

    def create
      notification.save

      respond_with notification
    end

    def destroy
      notification.destroy

      respond_with notification
    end

    private

    def notification_params
      params.require(:notification).permit(:type)
    end
  end
end
