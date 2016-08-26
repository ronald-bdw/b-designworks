module V1
  class AuthPhoneCodesController < ApplicationController
    wrap_parameters :auth_phone_code, include: %i(phone_number)

    def create
      result = SendPhoneCode.call(phone_number: auth_phone_code_params[:phone_number])

      respond_with(result.auth_phone_code)
    end

    private

    def auth_phone_code_params
      params.require(:auth_phone_code).permit(:phone_number)
    end
  end
end
