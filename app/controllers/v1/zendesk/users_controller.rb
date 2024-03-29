module V1
  module Zendesk
    class UsersController < ApplicationController
      before_action :authorize_zendesk_app!

      expose(:user, attributes: :user_params, finder: :find_by_zendesk_id)

      def show
        respond_with user, serializer: ::Zendesk::UserSerializer
      end

      def update
        user.save

        respond_with user
      end

      def fetch
        job = FetchUsersFromZendeskJob.perform_later(params[:notify_email])

        respond_with job
      end

      private

      def user_params
        ::Zendesk::UserParamsSanitizer.new(params).sanitized_params
      end
    end
  end
end
