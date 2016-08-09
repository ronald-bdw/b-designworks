module V1
  class RegistrationsController < Devise::RegistrationsController
    wrap_parameters :user

    def create
      user = CreateUser.call(user_params: user_params, plan_id: params[:plan_id]).user
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
  end
end
