module Users
  class UpdateToken
    include Interactor

    delegate :user, to: :context

    def call
      user.update(authentication_token: nil)
    end
  end
end
