module V1
  module Zendesk
    class NotificationSubscribersController < ApplicationController
      before_action :authorize_zendesk_app!

      expose(:notification_subscribers)
      expose(:notification_subscriber, attributes: :notification_subscriber_params)

      def create
        if notification_subscriber.save
          head :created
        else
          render json: { errors: notification_subscriber.errors.full_messages.join("\n") },
                 status: :unprocessable_entity
        end
      end

      def index
        render json: { notification_subscribers: notification_subscribers }
      end

      def destroy
        notification_subscriber.destroy

        respond_with notification_subscriber
      end

      private

      def notification_subscriber_params
        params.require(:notification_subscriber).permit(:email, notification_types: [])
      end
    end
  end
end
