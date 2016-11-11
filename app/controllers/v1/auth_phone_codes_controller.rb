module V1
  class AuthPhoneCodesController < ApplicationController
    wrap_parameters :auth_phone_code, include: %i(phone_number device_type)

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

    private

    def auth_phone_code_params
      params.require(:auth_phone_code).permit(:phone_number, :device_type)
    end
  end
end
