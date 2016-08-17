module Users
  class UpdateZendeskAccount
    include Interactor

    delegate :user, to: :context

    def call
      return if user.invalid?
      update_zendesk_user
      user.save
    end

    private

    def update_zendesk_user
      ZendeskAPI::User.update!(ZENDESK_CLIENT, zendesk_user_params)
    end

    def zendesk_user_params
      {
        id: user.zendesk_id,
        email: user.email,
        name: "#{user.first_name} #{user.last_name}",
        role: "end-user"
      }
    end
  end
end
