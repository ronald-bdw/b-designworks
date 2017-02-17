module V1
  class SessionsController < Devise::SessionsController
    wrap_parameters :user

    def create
      user = AuthenticateUser.call(warden: warden).user
      ::Users::Login.call(user: user, device: device)

      respond_with(user)
    end

    private

    def device
      request.headers["User-Agent"]
    end
  end
end
