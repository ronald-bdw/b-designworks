module V1
  class AuthPhoneCodesController < ApplicationController
    wrap_parameters :auth_phone_code, include: %i(phone_number)

    def create
      auth_phone_code = GenerateAuthPhoneCode
        .call(params: auth_phone_code_params).auth_phone_code

      respond_with(auth_phone_code)
    end

    private

    def auth_phone_code_params
      params.require(:auth_phone_code).permit(:phone_number)
    end
  end
end
