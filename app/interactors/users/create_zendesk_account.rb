module Users
  class CreateZendeskAccount
    include Interactor

    delegate :user, to: :context

    def call
      return if user.invalid?

      user.zendesk_id = zendesk_user.id
      user.save
    end

    private

    def zendesk_user
      @zendesk_user ||= ZendeskAPI::User.create(ZENDESK_CLIENT, zendesk_user_params)
    end

    def zendesk_user_params
      {
        email: user.email,
        name: "#{user.first_name} #{user.last_name}",
        phone: user.phone_number,
        role: "end-user"
      }
    end
  end
end
