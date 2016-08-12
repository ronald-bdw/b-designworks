module V1
  class SessionsController < Devise::SessionsController
    wrap_parameters :user

    def create
      byebug
      user = AuthenticateUser.call(warden: warden).user
      respond_with(user)
    end
  end
end
