module V1
  class RegistrationsController < Devise::RegistrationsController
    wrap_parameters :user

    def create
      result = CreateUser.call(
        user_params: user_params,
        auth_phone_code: auth_phone_code,
        sms_auth_code: params[:sms_code]
      )

      if result.success?
        respond_with result.user, status: :created
      else
        respond_with result.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :full_name,
        :email,
        :phone_number
      )
    end

    def auth_phone_code
      @auth_phone_code ||= AuthPhoneCode.unexpired.find_by(id: params[:auth_phone_code_id])
    end
  end
end
