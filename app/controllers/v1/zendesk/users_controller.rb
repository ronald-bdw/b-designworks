module V1
  module Zendesk
    class UsersController < ApplicationController
      before_action :authorize_zendesk_app!

      expose(:user, attributes: :user_params, finder: :find_by_zendesk_id)

      def update
        user.save

        respond_with user
      end

      def fetch
        job = FetchUsersFromZendeskJob.perform_later

        respond_with job
      end

      private

      def user_params
        attrs = params.require(:user).permit(:email, :name)

        if attrs[:name].present?
          attrs.merge!(Users::SplittedName.new(attrs[:name]).to_hash)
        end

        attrs
      end
    end
  end
end
