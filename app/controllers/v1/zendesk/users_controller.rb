module V1
  module Zendesk
    class UsersController < ApplicationController
      before_action :authorize_zendesk_app!

      expose(:user, attributes: :user_params, finder: :find_by_zendesk_id)

      def update
        user.save

        respond_with user
      end

      private

      def user_params
        attrs = params.require(:user).permit(:email, :name)

        if attrs[:name].present?
          splitted_name = attrs.delete(:name).split(" ", 2)
          name_attrs = Hash[%i(first_name last_name).zip(splitted_name)]
          attrs.merge!(name_attrs)
        end

        attrs
      end
    end
  end
end
