module V1
  module Users
    class TimeZonesController < ApplicationController
      acts_as_token_authentication_handler_for User, only: %i(update)

      def update
        ::Users::UpdateTimeZone.call(user: current_user, time_zone: time_zone_params[:time_zone])

        respond_with status: :ok
      end

      private

      def time_zone_params
        params.permit(:time_zone)
      end
    end
  end
end
