module V1
  class RegistrationsController < Devise::RegistrationsController
    wrap_parameters :user

    def create
      user = Users::Create.call(
        user_params: user_params,
        auth_phone_code: auth_phone_code,
        sms_auth_code: params[:sms_code]
      ).user

      respond_with user
    end

    private

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :phone_number
      )
    end

    def auth_phone_code
      @auth_phone_code ||= AuthPhoneCode.find_by(id: params[:auth_phone_code_id])
    end
  end
end
