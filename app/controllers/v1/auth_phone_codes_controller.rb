module V1
  class AuthPhoneCodesController < ApplicationController
    wrap_parameters :auth_phone_code, include: %i(phone_number device_type)

    expose(:auth_phone_code)

    def create
      result = SendPhoneCode.call(
        phone_number: auth_phone_code_params[:phone_number],
        device_type: auth_phone_code_params[:device_type]
      )

      if result.success?
        respond_with(result.auth_phone_code)
      else
        respond_with(result)
      end
    end

    def check
      if auth_phone_code.phone_code == params[:sms_code]
        head :ok
      else
        render json: { error: { status: 401, error: "Sms code is invalid" } }, status: :unauthorized
      end
    end

    private

    def auth_phone_code_params
      params.require(:auth_phone_code).permit(:phone_number, :device_type)
    end
  end
end
