module V1
  class SessionsController < Devise::SessionsController
    wrap_parameters :user

    def create
      user = AuthenticateUser.call(warden: warden).user
      Users::UpdateToken.call(user: user)
      FitnessTokens::DeleteAll.call(user: user)
      respond_with(user)
    end
  end
end
