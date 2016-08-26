module Users
  class Delete
    include Interactor

    delegate :user, :current_user, to: :context

    def call
      context.fail! if user != current_user

      delete_zendesk_account
      user.destroy!
    end

    private

    def delete_zendesk_account
      ZendeskAPI::User.destroy!(ZENDESK_CLIENT, id: user.zendesk_id)
    rescue ZendeskAPI::Error::RecordInvalid
      context.fail!
    end
  end
end
