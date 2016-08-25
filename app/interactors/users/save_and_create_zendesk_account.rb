module Users
  class SaveAndCreateZendeskAccount
    include Interactor

    delegate :user, to: :context

    def call
      return if user.invalid?

      if zendesk_user.save
        user.zendesk_id = zendesk_user.id
        user.save
      else
        user.errors.messages.merge!(zendesk_errors)
      end
    end

    private

    def zendesk_user
      @zendesk_user ||= ZendeskAPI::User.new(ZENDESK_CLIENT, zendesk_user_params)
    end

    def zendesk_errors
      Zendesk::HandleUserErrors.call(user_errors: zendesk_user.errors).errors
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
