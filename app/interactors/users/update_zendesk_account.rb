module Users
  class UpdateZendeskAccount
    include Interactor

    delegate :user, :photo, to: :context

    def call
      return if user.invalid?

      user.save if update_zendesk_user
    end

    private

    def update_zendesk_user
      ZendeskAPI::User.update!(ZENDESK_CLIENT, zendesk_user_params)
    rescue ZendeskAPI::Error::RecordInvalid => e
      errors = Zendesk::HandleUserErrors.call(user_errors: e.errors).errors
      user.errors.messages.merge!(errors)

      false
    end

    def zendesk_user_params
      {
        id: user.zendesk_id,
        email: user.email,
        name: "#{user.first_name} #{user.last_name}",
        photo: photo&.open
      }
    end
  end
end
