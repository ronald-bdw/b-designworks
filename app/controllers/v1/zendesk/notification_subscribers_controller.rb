module V1
  module Zendesk
    class NotificationSubscribersController < ApplicationController
      expose(:notification_subscriber, attributes: :notification_subscriber_params)

      def create
        notification_subscriber.save

        respond_with notification_subscriber
      end

      private

      def notification_subscriber_params
        params.require(:notification_subscriber).permit(:email, :notification_types)
      end
    end
  end
end
