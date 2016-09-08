module V1
  class UsersController < ApplicationController
    wrap_parameters :user

    acts_as_token_authentication_handler_for User, only: %i(update destroy account)

    expose(:user, attributes: :user_params)

    def account
      respond_with current_user
    end

    def create
      self.user = Users::Create.call(
        user_params: user_params,
        auth_phone_code: auth_phone_code,
        sms_auth_code: params[:sms_code]
      ).user

      respond_with user
    end

    def update
      self.user = Users::UpdateZendeskAccount.call(user: user, photo: user_params[:avatar]).user

      respond_with user
    end

    def destroy
      result = Users::Delete.call(user: user, current_user: current_user)
      status = result.success? ? :ok : :unprocessable_entity

      render nothing: true, status: status
    end

    private

    def user_params
      attributes = %i(first_name last_name email avatar)
      attributes << :phone_number if action_name == "create"

      params.require(:user).permit(attributes)
    end

    def auth_phone_code
      @auth_phone_code ||= AuthPhoneCode.find_by(id: params[:auth_phone_code_id])
    end
  end
end
